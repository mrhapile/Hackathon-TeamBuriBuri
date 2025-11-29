class SampleUser {
  final String id;
  final String name;
  final String avatar;
  final String branch;
  final int year;
  SampleUser({required this.id, required this.name, required this.avatar, required this.branch, required this.year});
}

class SamplePost {
  final String id;
  final String userId;
  final String title;
  final String body;
  final List<String> stacks;
  final String image;
  final String type;
  SamplePost({required this.id, required this.userId, required this.title, required this.body, required this.stacks, required this.image, required this.type});
}

final sampleUsers = <SampleUser>[
  SampleUser(id: 'u1', name: 'Jessica Pearson', avatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=400&auto=format&fit=crop', branch: 'CSE', year: 4),
  SampleUser(id: 'u2', name: 'Harvey Specter', avatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?q=80&w=400&auto=format&fit=crop', branch: 'ECE', year: 3),
  SampleUser(id: 'u3', name: 'Aisha Khan', avatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=400&auto=format&fit=crop', branch: 'IT', year: 2),
];

final samplePosts = <SamplePost>[
  SamplePost(
    id: 'p1',
    userId: 'u1',
    title: 'Built a new AI Résumé Parser',
    body: 'Just finished my final year project! It uses NLP to extract skills from PDFs automatically. Check it out on GitHub.',
    stacks: ['AI/ML', 'Python', 'NLP'],
    image: 'https://images.unsplash.com/photo-1555949963-ff9fe0c870eb?q=80&w=1600&auto=format&fit=crop',
    type: 'Project',
  ),
  SamplePost(
    id: 'p2',
    userId: 'u2',
    title: 'Hackathon Winners 2024! 🏆',
    body: 'Our team just won the state-level Hackathon for Smart City solutions using IoT sensors.',
    stacks: ['IoT', 'Hardware', 'Embedded'],
    image: 'https://images.unsplash.com/photo-1518770660439-4636190af475?q=80&w=1600&auto=format&fit=crop',
    type: 'Achievement',
  ),
  SamplePost(
    id: 'p3',
    userId: 'u3',
    title: 'Study Group Tonight',
    body: 'If anyone wants to join a group study session for DS & Algo at 7 PM in Library 2.',
    stacks: ['DSA', 'Algorithms'],
    image: 'https://images.unsplash.com/photo-1523240795612-9a054b0db644?q=80&w=1600&auto=format&fit=crop',
    type: 'Event',
  ),
];
