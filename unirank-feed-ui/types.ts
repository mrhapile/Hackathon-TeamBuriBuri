export interface User {
  id: string;
  firstName: string;
  fullName: string;
  avatarUrl: string;
  branch?: string;
  year?: string;
}

export interface Post {
  id: string;
  author: User;
  imageUrl: string;
  title: string;
  description: string;
  tags: string[];
  type: 'Event' | 'Project' | 'Achievement' | 'Question';
  likes: number;
  comments: number;
  timestamp: string;
}

export interface FilterOption {
  id: string;
  label: string;
}