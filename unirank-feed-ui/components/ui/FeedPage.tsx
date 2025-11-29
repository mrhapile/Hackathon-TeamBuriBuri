import React from 'react';
import TopNav from './TopNav';
import AvatarStories from './AvatarStories';
import StackFilters from './StackFilters';
import PostCard from './PostCard';
import { CURRENT_USER, STORY_USERS, FILTERS, FEED_POSTS } from '../../constants';

const FeedPage: React.FC = () => {
  return (
    <div className="min-h-screen bg-[#F8F7FC] flex flex-col">
      {/* 1. Top Navigation Bar */}
      <TopNav />

      {/* Main Content Area */}
      <main className="flex-grow max-w-7xl mx-auto w-full px-4 sm:px-6 lg:px-8 pb-20">
        
        {/* 2. Story Bubbles Row */}
        <section className="mt-6 sm:mt-8 mb-6">
           {/* Section Title (Optional but adds structure) */}
           <div className="px-2 mb-2">
             <h2 className="text-lg font-bold text-slate-800">Campus Stories</h2>
           </div>
           <AvatarStories users={STORY_USERS} currentUser={CURRENT_USER} />
        </section>

        {/* 3. Tech-Stack Filter Tabs */}
        <section className="mb-8 sticky top-20 z-40 bg-[#F8F7FC]/90 backdrop-blur-sm py-2 -mx-4 px-4 sm:mx-0 sm:px-0">
           <StackFilters filters={FILTERS} />
        </section>

        {/* 4. Feed Cards (Main Section) */}
        <section className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 sm:gap-8 lg:gap-10">
          {FEED_POSTS.map((post) => (
            <PostCard key={post.id} post={post} />
          ))}
          
          {/* Mock Loading Card / Skeleton for infinite scroll feel */}
          <div className="hidden md:flex flex-col h-full bg-white rounded-3xl shadow-sm border border-slate-100 overflow-hidden opacity-60">
             <div className="h-48 bg-slate-100 animate-pulse"></div>
             <div className="p-6 space-y-4">
               <div className="flex gap-2">
                 <div className="h-6 w-16 bg-slate-100 rounded-md animate-pulse"></div>
                 <div className="h-6 w-16 bg-slate-100 rounded-md animate-pulse"></div>
               </div>
               <div className="h-6 w-3/4 bg-slate-100 rounded-full animate-pulse"></div>
               <div className="space-y-2">
                 <div className="h-4 w-full bg-slate-100 rounded-full animate-pulse"></div>
                 <div className="h-4 w-5/6 bg-slate-100 rounded-full animate-pulse"></div>
               </div>
             </div>
          </div>
        </section>

        {/* Footer/End of feed indicator */}
        <div className="mt-12 text-center">
          <p className="text-slate-400 text-sm font-medium">
             You're all caught up! 🎉
          </p>
        </div>

      </main>
    </div>
  );
};

export default FeedPage;