-- Enable UUID extension
create extension if not exists "uuid-ossp";

-- 1. PROFILES TABLE
-- Public profiles for each user, linked to auth.users
create table public.profiles (
  id uuid not null references auth.users(id) on delete cascade primary key,
  name text not null,
  email text,
  avatar_url text,
  branch text,
  year integer,
  college text,
  attendance integer default 0,
  github_username text,
  leetcode_id text,
  codeforces_id text,
  created_at timestamp with time zone default now() not null
);

-- 2. POSTS TABLE
-- Content posts by users
create table public.posts (
  id uuid not null default gen_random_uuid() primary key,
  user_id uuid not null references public.profiles(id) on delete cascade,
  college text, -- Can be used to filter posts by college
  category text, -- Web Dev, AI/ML, App Dev, DSA, etc.
  title text,
  description text,
  media_url text,
  created_at timestamp with time zone default now() not null
);

-- 3. LIKES TABLE
-- Likes on posts
create table public.likes (
  id uuid not null default gen_random_uuid() primary key,
  post_id uuid not null references public.posts(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  created_at timestamp with time zone default now() not null,
  unique(post_id, user_id) -- Prevent duplicate likes
);

-- 4. COMMENTS TABLE
-- Comments on posts
create table public.comments (
  id uuid not null default gen_random_uuid() primary key,
  post_id uuid not null references public.posts(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  text text not null,
  created_at timestamp with time zone default now() not null
);

-- 5. STORIES TABLE
-- Ephemeral stories (logic for expiration handled in query or app)
create table public.stories (
  id uuid not null default gen_random_uuid() primary key,
  user_id uuid not null references public.profiles(id) on delete cascade,
  media_url text not null,
  created_at timestamp with time zone default now() not null,
  expires_at timestamp with time zone not null
);

-- 6. CONTRIBUTIONS TABLE
-- For GitHub/LeetCode/CodeForces heatmap data
create table public.contributions (
  id uuid not null default gen_random_uuid() primary key,
  user_id uuid not null references public.profiles(id) on delete cascade,
  date date not null,
  count integer default 0,
  unique(user_id, date) -- One entry per user per date
);

-- INDEXES FOR PERFORMANCE
create index idx_posts_created_at on public.posts(created_at desc);
create index idx_posts_user_id on public.posts(user_id);
create index idx_posts_college on public.posts(college);

create index idx_likes_post_id on public.likes(post_id);
create index idx_likes_user_id on public.likes(user_id);

create index idx_comments_post_id on public.comments(post_id);
create index idx_comments_user_id on public.comments(user_id);

create index idx_stories_user_id on public.stories(user_id);
create index idx_stories_expires_at on public.stories(expires_at);

create index idx_contributions_user_id on public.contributions(user_id);
create index idx_contributions_date on public.contributions(date);

-- RLS POLICIES (Disabled for now as requested, but good practice to enable later)
alter table public.profiles enable row level security;
alter table public.posts enable row level security;
alter table public.likes enable row level security;
alter table public.comments enable row level security;
alter table public.stories enable row level security;
alter table public.contributions enable row level security;

-- Create policies to allow public read access (optional, for development)
create policy "Public profiles are viewable by everyone" on public.profiles for select using (true);
create policy "Public posts are viewable by everyone" on public.posts for select using (true);
create policy "Public likes are viewable by everyone" on public.likes for select using (true);
create policy "Public comments are viewable by everyone" on public.comments for select using (true);
create policy "Public stories are viewable by everyone" on public.stories for select using (true);
create policy "Public contributions are viewable by everyone" on public.contributions for select using (true);

-- Allow authenticated users to insert/update their own data (basic examples)
create policy "Users can insert their own profile" on public.profiles for insert with check (auth.uid() = id);
create policy "Users can update their own profile" on public.profiles for update using (auth.uid() = id);

create policy "Users can insert their own posts" on public.posts for insert with check (auth.uid() = user_id);
create policy "Users can update their own posts" on public.posts for update using (auth.uid() = user_id);
create policy "Users can delete their own posts" on public.posts for delete using (auth.uid() = user_id);

create policy "Users can insert their own likes" on public.likes for insert with check (auth.uid() = user_id);
create policy "Users can delete their own likes" on public.likes for delete using (auth.uid() = user_id);

create policy "Users can insert their own comments" on public.comments for insert with check (auth.uid() = user_id);
create policy "Users can delete their own comments" on public.comments for delete using (auth.uid() = user_id);

create policy "Users can insert their own stories" on public.stories for insert with check (auth.uid() = user_id);
create policy "Users can delete their own stories" on public.stories for delete using (auth.uid() = user_id);

create policy "Users can insert their own contributions" on public.contributions for insert with check (auth.uid() = user_id);
