import React from 'react';

interface TagProps {
  text: string;
}

const Tag: React.FC<TagProps> = ({ text }) => {
  // Generate a consistent pastel color based on string length/char code to make it look varied but deterministic
  const getColor = (str: string) => {
    const colors = [
      'bg-blue-100 text-blue-700',
      'bg-purple-100 text-purple-700',
      'bg-pink-100 text-pink-700',
      'bg-indigo-100 text-indigo-700',
      'bg-teal-100 text-teal-700',
      'bg-orange-100 text-orange-700',
    ];
    let hash = 0;
    for (let i = 0; i < str.length; i++) {
      hash = str.charCodeAt(i) + ((hash << 5) - hash);
    }
    return colors[Math.abs(hash) % colors.length];
  };

  return (
    <span className={`text-[10px] uppercase tracking-wider font-bold px-2 py-1 rounded-md ${getColor(text)}`}>
      {text}
    </span>
  );
};

export default Tag;