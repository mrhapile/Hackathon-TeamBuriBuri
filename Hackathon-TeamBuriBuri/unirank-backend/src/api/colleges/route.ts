import { createClient } from '@/utils/supabase/server';
import { NextResponse } from 'next/server';

export async function GET(request: Request) {
    const { searchParams } = new URL(request.url);
    const query = searchParams.get('q') || '';

    const supabase = createClient();

    let dbQuery = supabase
        .from('students')
        .select('college')
        .not('college', 'is', null);

    if (query) {
        dbQuery = dbQuery.ilike('college', `%${query}%`);
    }

    // Since we don't have a separate colleges table, we fetch distinct from students or leaderboard_cache
    // Using leaderboard_cache is better as it was seeded with colleges
    const { data, error } = await supabase
        .from('leaderboard_cache')
        .select('college')
        .ilike('college', `%${query}%`);

    if (error) {
        return NextResponse.json({ error: error.message }, { status: 500 });
    }

    // Dedup just in case
    const colleges = Array.from(new Set(data.map(item => item.college)));

    return NextResponse.json({ colleges });
}
