import React from 'react';
import { Post } from '../../types';
import { MessageCircle, Share2, MoreHorizontal, ArrowUpRight } from 'lucide-react';
import Tag from './Tag';
import LikeButton from './LikeButton';

interface PostCardProps {
  post: Post;
}

const PostCard: React.FC<PostCardProps> = ({ post }) => {
  return (
    <div className="group bg-white rounded-3xl overflow-hidden shadow-lg shadow-purple-100/50 hover:shadow-2xl hover:shadow-purple-200/50 hover:-translate-y-1 transition-all duration-300 cursor-pointer border border-slate-100 flex flex-col h-full">
      {/* Image Section - Takes up significant height */}
      <div className="relative h-48 sm:h-56 w-full overflow-hidden">
        <img 
          src={post.imageUrl} 
          alt={post.title} 
          className="w-full h-full object-cover transition-transform duration-700 group-hover:scale-105"
        />
        
        {/* Top Overlay - Type Badge */}
        <div className="absolute top-4 left-4">
           <span className="bg-black/30 backdrop-blur-md text-white text-xs font-semibold px-3 py-1.5 rounded-full border border-white/20">
            {post.type}
           </span>
        </div>

        {/* Top Overlay - View Action */}
        <div className="absolute top-4 right-4 opacity-0 group-hover:opacity-100 transition-opacity duration-300">
           <button className="bg-white/90 backdrop-blur-md text-slate-800 text-xs font-bold px-3 py-1.5 rounded-full shadow-lg flex items-center gap-1 hover:bg-white">
            View <ArrowUpRight size={14} />
           </button>
        </div>

        {/* Bottom Overlay - Author Info */}
        <div className="absolute bottom-0 left-0 right-0 p-4 bg-gradient-to-t from-black/80 via-black/40 to-transparent pt-12">
           <div className="flex items-center gap-3">
             <div className="relative">
               <img 
                 src={post.author.avatarUrl} 
                 alt={post.author.fullName} 
                 className="w-10 h-10 rounded-full border-2 border-white/80 shadow-md"
               />
               <div className="absolute bottom-0 right-0 w-3 h-3 bg-green-400 border-2 border-black rounded-full"></div>
             </div>
             <div className="text-white">
               <h4 className="font-bold text-sm leading-tight">{post.author.fullName}</h4>
               <p className="text-xs text-white/80 font-medium">{post.author.branch} • {post.author.year}</p>
             </div>
           </div>
        </div>
      </div>

      {/* Content Section */}
      <div className="p-5 flex flex-col flex-grow">
        {/* Tags */}
        <div className="flex flex-wrap gap-2 mb-3">
          {post.tags.map(tag => (
            <Tag key={tag} text={tag} />
          ))}
        </div>

        {/* Title & Desc */}
        <h3 className="text-lg font-bold text-slate-800 mb-2 line-clamp-1 group-hover:text-purple-700 transition-colors">
          {post.title}
        </h3>
        <p className="text-slate-500 text-sm leading-relaxed mb-4 line-clamp-2 flex-grow">
          {post.description}
        </p>

        {/* Divider */}
        <div className="h-px w-full bg-slate-100 mb-4"></div>

        {/* Actions Row */}
        <div className="flex items-center justify-between mt-auto">
          <div className="flex items-center gap-4">
            <LikeButton initialCount={post.likes} />
            
            <button className="flex items-center gap-1.5 text-slate-500 hover:text-indigo-600 transition-colors group/comment">
               <div className="p-2 rounded-full group-hover/comment:bg-indigo-50 transition-colors">
                <MessageCircle size={20} />
               </div>
               <span className="text-sm font-medium">{post.comments}</span>
            </button>
          </div>

          <button className="text-slate-400 hover:text-slate-600 p-2 hover:bg-slate-50 rounded-full transition-colors">
            <Share2 size={18} />
          </button>
        </div>
      </div>
    </div>
  );
};

export default PostCard;