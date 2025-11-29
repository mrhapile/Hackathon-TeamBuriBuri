import { createClient } from '@/utils/supabase/server';
import { NextResponse } from 'next/server';

export async function GET(
    request: Request,
    { params }: { params: { college: string } }
) {
    const collegeName = decodeURIComponent(params.college);
    const supabase = createClient();

    const { data, error } = await supabase
        .from('students')
        .select('id, name, avatar_url, pro_score, branch, year')
        .eq('college', collegeName)
        .order('pro_score', { ascending: false })
        .limit(10);

    if (error) {
        return NextResponse.json({ error: error.message }, { status: 500 });
    }

    return NextResponse.json({ students: data });
}
