import React, { useState } from 'react';
import { FilterOption } from '../../types';

interface StackFiltersProps {
  filters: FilterOption[];
}

const StackFilters: React.FC<StackFiltersProps> = ({ filters }) => {
  const [activeId, setActiveId] = useState<string>('all');

  return (
    <div className="w-full overflow-x-auto no-scrollbar py-2 pl-4 sm:pl-0">
      <div className="flex items-center gap-3 min-w-max px-2">
        {filters.map((filter) => {
          const isActive = activeId === filter.id;
          return (
            <button
              key={filter.id}
              onClick={() => setActiveId(filter.id)}
              className={`
                px-6 py-2.5 rounded-full text-sm font-semibold transition-all duration-300
                ${isActive 
                  ? 'bg-gradient-to-r from-purple-600 to-indigo-600 text-white shadow-lg shadow-purple-200 scale-105' 
                  : 'bg-white text-slate-500 hover:bg-purple-50 hover:text-purple-600 border border-slate-200/60 shadow-sm'
                }
              `}
            >
              {filter.label}
            </button>
          );
        })}
      </div>
    </div>
  );
};

export default StackFilters;