import React, { useState } from 'react';
import { Heart } from 'lucide-react';

interface LikeButtonProps {
  initialCount: number;
}

const LikeButton: React.FC<LikeButtonProps> = ({ initialCount }) => {
  const [liked, setLiked] = useState(false);
  const [count, setCount] = useState(initialCount);

  const handleLike = (e: React.MouseEvent) => {
    e.stopPropagation(); // Prevent card click
    if (liked) {
      setCount(prev => prev - 1);
    } else {
      setCount(prev => prev + 1);
    }
    setLiked(!liked);
  };

  return (
    <button 
      onClick={handleLike}
      className="flex items-center gap-1.5 text-slate-500 hover:text-pink-600 transition-colors group"
    >
      <div className={`p-2 rounded-full transition-all duration-300 ${liked ? 'bg-pink-100 text-pink-600 scale-110' : 'group-hover:bg-pink-50'}`}>
        <Heart 
          size={20} 
          className={`transition-transform duration-300 ${liked ? 'fill-current' : ''}`} 
        />
      </div>
      <span className={`text-sm font-medium ${liked ? 'text-pink-600' : ''}`}>
        {count}
      </span>
    </button>
  );
};

export default LikeButton;