import { NextResponse } from 'next/server';

export async function GET(
    request: Request,
    { params }: { params: { platform: string; username: string } }
) {
    const { platform, username } = params;

    // Mock implementation as requested if no API available
    // But for these platforms, we can try to fetch or return mock data
    // Prompt says: "If the platform has no API → use mock or recommended provider."

    // We will return mock data structure for heatmaps
    const mockData = {
        platform,
        username,
        total_solved: Math.floor(Math.random() * 500),
        heatmap: Array.from({ length: 30 }, (_, i) => ({
            date: new Date(Date.now() - i * 24 * 60 * 60 * 1000).toISOString().split('T')[0],
            count: Math.floor(Math.random() * 5)
        })).reverse()
    };

    return NextResponse.json(mockData);
}
