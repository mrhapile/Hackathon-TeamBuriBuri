import { createClient } from '@/utils/supabase/server';
import { NextResponse } from 'next/server';

export async function POST(request: Request) {
    const supabase = createClient();

    // Check Auth
    const { data: { user }, error: authError } = await supabase.auth.getUser();
    if (authError || !user) {
        return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });
    }

    const { attendance } = await request.json();

    if (typeof attendance !== 'number' || attendance < 0 || attendance > 100) {
        return NextResponse.json({ error: 'Invalid attendance value' }, { status: 400 });
    }

    // Update attendance
    // We need to find the student record associated with this auth_user
    const { data: student, error: fetchError } = await supabase
        .from('students')
        .select('id')
        .eq('auth_id', user.id)
        .single();

    if (fetchError || !student) {
        return NextResponse.json({ error: 'Student profile not found' }, { status: 404 });
    }

    const { error: updateError } = await supabase
        .from('students')
        .update({ attendance })
        .eq('id', student.id);

    if (updateError) {
        return NextResponse.json({ error: updateError.message }, { status: 500 });
    }

    // Recalculate Score
    // We can call the database function directly via RPC
    const { error: rpcError } = await supabase.rpc('calculate_pro_score', { student_uuid: student.id });

    if (rpcError) {
        return NextResponse.json({ error: 'Failed to recalculate score: ' + rpcError.message }, { status: 500 });
    }

    return NextResponse.json({ success: true, message: 'Attendance updated and score recalculated' });
}
