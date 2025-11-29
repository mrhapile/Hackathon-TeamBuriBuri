-- Enable RLS on all tables
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.posts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.likes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.comments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.stories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.contributions ENABLE ROW LEVEL SECURITY;

-- Helper function to get the current user's college
-- This avoids infinite recursion when querying the profiles table within a policy
CREATE OR REPLACE FUNCTION get_my_college()
RETURNS text
LANGUAGE sql
SECURITY DEFINER
SET search_path = public
STABLE
AS $$
  SELECT college FROM profiles WHERE id = auth.uid();
$$;

-- ===========================
-- 1. PROFILES TABLE RLS
-- ===========================

-- Allow users to read their own profile and profiles from the same college
DROP POLICY IF EXISTS "Read access for same college" ON public.profiles;
CREATE POLICY "Read access for same college"
ON public.profiles FOR SELECT
USING (
  id = auth.uid() OR college = get_my_college()
);

-- Allow users to update only their own profile
DROP POLICY IF EXISTS "Update own profile" ON public.profiles;
CREATE POLICY "Update own profile"
ON public.profiles FOR UPDATE
USING (id = auth.uid());

-- Allow service role to insert (for auth triggers)
DROP POLICY IF EXISTS "Service role insert" ON public.profiles;
CREATE POLICY "Service role insert"
ON public.profiles FOR INSERT
WITH CHECK (auth.role() = 'service_role');

-- ===========================
-- 2. POSTS TABLE RLS
-- ===========================

-- Read: Students see posts only from their own college
DROP POLICY IF EXISTS "Read posts from same college" ON public.posts;
CREATE POLICY "Read posts from same college"
ON public.posts FOR SELECT
USING (
  college = get_my_college()
);

-- Insert: Create posts only for own profile/college
-- Enforce that the post's college matches the user's college
DROP POLICY IF EXISTS "Create posts" ON public.posts;
CREATE POLICY "Create posts"
ON public.posts FOR INSERT
WITH CHECK (
  user_id = auth.uid() AND college = get_my_college()
);

-- Update: Only own posts
DROP POLICY IF EXISTS "Update own posts" ON public.posts;
CREATE POLICY "Update own posts"
ON public.posts FOR UPDATE
USING (user_id = auth.uid());

-- Delete: Only own posts
DROP POLICY IF EXISTS "Delete own posts" ON public.posts;
CREATE POLICY "Delete own posts"
ON public.posts FOR DELETE
USING (user_id = auth.uid());

-- ===========================
-- 3. LIKES TABLE RLS
-- ===========================

-- Read: Likes on posts from same college
DROP POLICY IF EXISTS "Read likes from same college" ON public.likes;
CREATE POLICY "Read likes from same college"
ON public.likes FOR SELECT
USING (
  post_id IN (SELECT id FROM posts WHERE college = get_my_college())
);

-- Insert: Like posts
DROP POLICY IF EXISTS "Create likes" ON public.likes;
CREATE POLICY "Create likes"
ON public.likes FOR INSERT
WITH CHECK (user_id = auth.uid());

-- Delete: Unlike (own likes only)
DROP POLICY IF EXISTS "Delete own likes" ON public.likes;
CREATE POLICY "Delete own likes"
ON public.likes FOR DELETE
USING (user_id = auth.uid());

-- ===========================
-- 4. COMMENTS TABLE RLS
-- ===========================

-- Read: Comments on posts from same college
DROP POLICY IF EXISTS "Read comments from same college" ON public.comments;
CREATE POLICY "Read comments from same college"
ON public.comments FOR SELECT
USING (
  post_id IN (SELECT id FROM posts WHERE college = get_my_college())
);

-- Insert: Comment on posts
DROP POLICY IF EXISTS "Create comments" ON public.comments;
CREATE POLICY "Create comments"
ON public.comments FOR INSERT
WITH CHECK (user_id = auth.uid());

-- Update: Own comments only
DROP POLICY IF EXISTS "Update own comments" ON public.comments;
CREATE POLICY "Update own comments"
ON public.comments FOR UPDATE
USING (user_id = auth.uid());

-- Delete: Own comments only
DROP POLICY IF EXISTS "Delete own comments" ON public.comments;
CREATE POLICY "Delete own comments"
ON public.comments FOR DELETE
USING (user_id = auth.uid());

-- ===========================
-- 5. STORIES TABLE RLS
-- ===========================

-- Read: Stories from same college users
DROP POLICY IF EXISTS "Read stories from same college" ON public.stories;
CREATE POLICY "Read stories from same college"
ON public.stories FOR SELECT
USING (
  user_id IN (SELECT id FROM profiles WHERE college = get_my_college())
);

-- Insert: Create own stories
DROP POLICY IF EXISTS "Create stories" ON public.stories;
CREATE POLICY "Create stories"
ON public.stories FOR INSERT
WITH CHECK (user_id = auth.uid());

-- Update: Own stories only
DROP POLICY IF EXISTS "Update own stories" ON public.stories;
CREATE POLICY "Update own stories"
ON public.stories FOR UPDATE
USING (user_id = auth.uid());

-- Delete: Own stories only
DROP POLICY IF EXISTS "Delete own stories" ON public.stories;
CREATE POLICY "Delete own stories"
ON public.stories FOR DELETE
USING (user_id = auth.uid());

-- ===========================
-- 6. CONTRIBUTIONS TABLE RLS
-- ===========================

-- Read: Own contributions only
DROP POLICY IF EXISTS "Read own contributions" ON public.contributions;
CREATE POLICY "Read own contributions"
ON public.contributions FOR SELECT
USING (user_id = auth.uid());

-- Insert: Own contributions only
DROP POLICY IF EXISTS "Create contributions" ON public.contributions;
CREATE POLICY "Create contributions"
ON public.contributions FOR INSERT
WITH CHECK (user_id = auth.uid());

-- Update: Own contributions only
DROP POLICY IF EXISTS "Update own contributions" ON public.contributions;
CREATE POLICY "Update own contributions"
ON public.contributions FOR UPDATE
USING (user_id = auth.uid());

-- Delete: Own contributions only
DROP POLICY IF EXISTS "Delete own contributions" ON public.contributions;
CREATE POLICY "Delete own contributions"
ON public.contributions FOR DELETE
USING (user_id = auth.uid());
