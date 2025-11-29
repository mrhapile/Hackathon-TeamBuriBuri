import React from 'react';
import { User } from '../../types';
import { Plus } from 'lucide-react';

interface AvatarStoriesProps {
  users: User[];
  currentUser: User;
}

const AvatarStories: React.FC<AvatarStoriesProps> = ({ users, currentUser }) => {
  return (
    <div className="w-full overflow-x-auto no-scrollbar py-4 pl-4 sm:pl-0">
      <div className="flex items-start gap-4 sm:gap-6 min-w-max px-2">
        {/* Current User 'Add Story' Bubble */}
        <div className="flex flex-col items-center gap-2 cursor-pointer group">
          <div className="relative">
            <div className="w-16 h-16 sm:w-20 sm:h-20 rounded-full p-[2px] border-2 border-dashed border-purple-300 group-hover:border-purple-500 transition-colors flex items-center justify-center">
               <img 
                 src={currentUser.avatarUrl} 
                 alt="You" 
                 className="w-full h-full rounded-full object-cover opacity-80 group-hover:opacity-100 transition-opacity"
               />
            </div>
            <div className="absolute bottom-0 right-0 bg-purple-600 text-white p-1 rounded-full shadow-lg border-2 border-white group-hover:scale-110 transition-transform">
              <Plus size={14} strokeWidth={3} />
            </div>
          </div>
          <span className="text-xs font-medium text-slate-600 group-hover:text-purple-700">You</span>
        </div>

        {/* Other Users */}
        {users.map((user) => (
          <div key={user.id} className="flex flex-col items-center gap-2 cursor-pointer group">
            <div className="w-16 h-16 sm:w-20 sm:h-20 rounded-full p-[2px] bg-gradient-to-tr from-purple-500 to-pink-500 shadow-sm group-hover:shadow-md group-hover:shadow-purple-200 transition-all group-hover:scale-105">
              <div className="bg-white p-[2px] rounded-full w-full h-full">
                <img 
                  src={user.avatarUrl} 
                  alt={user.firstName} 
                  className="w-full h-full rounded-full object-cover"
                />
              </div>
            </div>
            <span className="text-xs font-medium text-slate-600 group-hover:text-purple-700">{user.firstName}</span>
          </div>
        ))}
      </div>
    </div>
  );
};

export default AvatarStories;