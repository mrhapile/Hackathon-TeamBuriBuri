import { createClient } from '@/utils/supabase/server';
import { NextResponse } from 'next/server';

export async function POST(request: Request) {
    const supabase = createClient();

    // Check Auth
    const { data: { user }, error: authError } = await supabase.auth.getUser();
    if (authError || !user) {
        return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });
    }

    const { title, description, repo_url } = await request.json();

    if (!title || !description || !repo_url) {
        return NextResponse.json({ error: 'Missing required fields' }, { status: 400 });
    }

    // Get student ID
    const { data: student, error: fetchError } = await supabase
        .from('students')
        .select('id')
        .eq('auth_id', user.id)
        .single();

    if (fetchError || !student) {
        return NextResponse.json({ error: 'Student profile not found' }, { status: 404 });
    }

    // Insert Project
    const { error: insertError } = await supabase
        .from('projects')
        .insert({
            student_id: student.id,
            title,
            description,
            repo_url
        });

    if (insertError) {
        return NextResponse.json({ error: insertError.message }, { status: 500 });
    }

    // Recalculate Score
    const { error: rpcError } = await supabase.rpc('calculate_pro_score', { student_uuid: student.id });

    if (rpcError) {
        return NextResponse.json({ error: 'Failed to recalculate score: ' + rpcError.message }, { status: 500 });
    }

    return NextResponse.json({ success: true, message: 'Project added and score recalculated' });
}
