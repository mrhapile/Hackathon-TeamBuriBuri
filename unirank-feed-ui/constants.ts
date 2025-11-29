import { Post, User, FilterOption } from './types';

export const CURRENT_USER: User = {
  id: 'u1',
  firstName: 'Alex',
  fullName: 'Alex Johnson',
  avatarUrl: 'https://picsum.photos/id/64/100/100',
  branch: 'CSE',
  year: '3rd Year'
};

export const STORY_USERS: User[] = [
  { id: 'u2', firstName: 'Sarah', fullName: 'Sarah Connor', avatarUrl: 'https://picsum.photos/id/65/100/100' },
  { id: 'u3', firstName: 'Mike', fullName: 'Mike Ross', avatarUrl: 'https://picsum.photos/id/91/100/100' },
  { id: 'u4', firstName: 'Jessica', fullName: 'Jessica Pearson', avatarUrl: 'https://picsum.photos/id/177/100/100' },
  { id: 'u5', firstName: 'Harvey', fullName: 'Harvey Specter', avatarUrl: 'https://picsum.photos/id/237/100/100' },
  { id: 'u6', firstName: 'Louis', fullName: 'Louis Litt', avatarUrl: 'https://picsum.photos/id/338/100/100' },
  { id: 'u7', firstName: 'Donna', fullName: 'Donna Paulsen', avatarUrl: 'https://picsum.photos/id/342/100/100' },
  { id: 'u8', firstName: 'Rachel', fullName: 'Rachel Zane', avatarUrl: 'https://picsum.photos/id/433/100/100' },
  { id: 'u9', firstName: 'Katrina', fullName: 'Katrina Bennett', avatarUrl: 'https://picsum.photos/id/449/100/100' },
  { id: 'u10', firstName: 'Samantha', fullName: 'Samantha Wheeler', avatarUrl: 'https://picsum.photos/id/531/100/100' },
];

export const FILTERS: FilterOption[] = [
  { id: 'all', label: 'All' },
  { id: 'web', label: 'Web Dev' },
  { id: 'ai', label: 'AI/ML' },
  { id: 'app', label: 'App Dev' },
  { id: 'dsa', label: 'DSA' },
  { id: 'cloud', label: 'Cloud' },
  { id: 'backend', label: 'Backend' },
  { id: 'java', label: 'Java' },
  { id: 'python', label: 'Python' },
  { id: 'design', label: 'UI/UX' },
];

export const FEED_POSTS: Post[] = [
  {
    id: 'p1',
    author: {
      id: 'u4',
      firstName: 'Jessica',
      fullName: 'Jessica Pearson',
      avatarUrl: 'https://picsum.photos/id/177/100/100',
      branch: 'CSE',
      year: '4th Year'
    },
    imageUrl: 'https://picsum.photos/id/1/800/600',
    title: 'Built a new AI Resumé Parser',
    description: 'Just finished my final year project! It uses NLP to extract skills from PDFs automatically. Check it out on GitHub.',
    tags: ['AI/ML', 'Python', 'NLP'],
    type: 'Project',
    likes: 124,
    comments: 42,
    timestamp: '2h ago'
  },
  {
    id: 'p2',
    author: {
      id: 'u5',
      firstName: 'Harvey',
      fullName: 'Harvey Specter',
      avatarUrl: 'https://picsum.photos/id/237/100/100',
      branch: 'ECE',
      year: '3rd Year'
    },
    imageUrl: 'https://picsum.photos/id/26/800/600',
    title: 'Hackathon Winners 2024! 🏆',
    description: 'Our team "Pearson Hardman" just won the state-level Hackathon for our Smart City solution using IoT sensors.',
    tags: ['IoT', 'Hardware', 'Achievement'],
    type: 'Achievement',
    likes: 856,
    comments: 120,
    timestamp: '5h ago'
  },
  {
    id: 'p3',
    author: {
      id: 'u3',
      firstName: 'Mike',
      fullName: 'Mike Ross',
      avatarUrl: 'https://picsum.photos/id/91/100/100',
      branch: 'IT',
      year: '2nd Year'
    },
    imageUrl: 'https://picsum.photos/id/60/800/600',
    title: 'Intro to React Workshop',
    description: 'Conducting a workshop for freshers on React basics and Hooks. Join us at the seminar hall tomorrow at 4 PM.',
    tags: ['React', 'Web Dev', 'Event'],
    type: 'Event',
    likes: 45,
    comments: 12,
    timestamp: '1d ago'
  },
  {
    id: 'p4',
    author: {
      id: 'u8',
      firstName: 'Rachel',
      fullName: 'Rachel Zane',
      avatarUrl: 'https://picsum.photos/id/433/100/100',
      branch: 'CSE',
      year: '3rd Year'
    },
    imageUrl: 'https://picsum.photos/id/119/800/600',
    title: 'Best resources for System Design?',
    description: 'I am preparing for internships. Can anyone suggest good resources or books for HLD and LLD?',
    tags: ['DSA', 'System Design', 'Question'],
    type: 'Question',
    likes: 22,
    comments: 34,
    timestamp: '1d ago'
  },
  {
    id: 'p5',
    author: {
      id: 'u6',
      firstName: 'Louis',
      fullName: 'Louis Litt',
      avatarUrl: 'https://picsum.photos/id/338/100/100',
      branch: 'Mech',
      year: '4th Year'
    },
    imageUrl: 'https://picsum.photos/id/201/800/600',
    title: 'Robotics Club Recruitment',
    description: 'We are looking for members interested in Arduino and mechanical design for the upcoming Robowars.',
    tags: ['Robotics', 'C++', 'Event'],
    type: 'Event',
    likes: 67,
    comments: 8,
    timestamp: '2d ago'
  },
];