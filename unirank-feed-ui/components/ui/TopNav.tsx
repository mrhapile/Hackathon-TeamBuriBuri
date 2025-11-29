import React, { useState } from 'react';
import { MessageSquareText, Search, GraduationCap } from 'lucide-react';

const TopNav: React.FC = () => {
  const [activeTab, setActiveTab] = useState('discover');

  return (
    <div className="sticky top-0 z-50 w-full bg-slate-900/95 backdrop-blur-xl border-b border-white/10 text-white shadow-2xl shadow-purple-900/10">
      {/* Decorative gradient line at bottom */}
      <div className="absolute bottom-0 left-0 w-full h-[1px] bg-gradient-to-r from-transparent via-purple-500/50 to-transparent"></div>

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 h-16 sm:h-20 flex items-center justify-between gap-4">
        
        {/* Left: Logo */}
        <div className="flex items-center gap-3 cursor-pointer group">
          <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-purple-500 to-indigo-600 flex items-center justify-center shadow-lg shadow-purple-500/20 group-hover:shadow-purple-500/40 transition-all">
            <GraduationCap className="text-white" size={24} />
          </div>
          <span className="font-bold text-xl tracking-tight hidden sm:block group-hover:text-purple-200 transition-colors">
            Uni<span className="text-purple-400">Rank</span>
          </span>
        </div>

        {/* Center: Navigation Pills */}
        <div className="flex items-center p-1.5 bg-white/5 rounded-full border border-white/10 backdrop-blur-sm">
          {['Discover', 'Messages', 'Settings'].map((tab) => {
            const isActive = activeTab === tab.toLowerCase();
            return (
              <button
                key={tab}
                onClick={() => setActiveTab(tab.toLowerCase())}
                className={`
                  relative px-5 py-2 rounded-full text-sm font-medium transition-all duration-300
                  ${isActive ? 'text-white' : 'text-slate-400 hover:text-white'}
                `}
              >
                {isActive && (
                  <div className="absolute inset-0 bg-gradient-to-r from-purple-600 to-indigo-600 rounded-full -z-10 shadow-md"></div>
                )}
                {tab}
              </button>
            );
          })}
        </div>

        {/* Right: Actions */}
        <div className="flex items-center gap-4">
          <button className="hidden sm:flex items-center justify-center w-10 h-10 rounded-full bg-white/5 hover:bg-white/10 text-slate-300 hover:text-white transition-all">
            <Search size={20} />
          </button>
          
          <button className="relative flex items-center justify-center w-10 h-10 rounded-full bg-gradient-to-br from-purple-500/20 to-indigo-500/20 hover:from-purple-500/40 hover:to-indigo-500/40 border border-white/10 transition-all group">
            <MessageSquareText size={20} className="text-purple-300 group-hover:text-white transition-colors" />
            <span className="absolute top-2 right-2 w-2.5 h-2.5 bg-red-500 border-2 border-slate-900 rounded-full"></span>
          </button>

          {/* Mobile Menu Placeholder (Optional) */}
          <div className="sm:hidden w-8 h-8 rounded-full bg-slate-800 border border-white/10"></div>
        </div>
      </div>
    </div>
  );
};

export default TopNav;