import { createClient } from '@/utils/supabase/server';
import { NextResponse } from 'next/server';

export async function GET(
    request: Request,
    { params }: { params: { id: string } }
) {
    const studentId = params.id;
    const supabase = createClient();

    // Fetch student details
    const { data: student, error: studentError } = await supabase
        .from('students')
        .select('*')
        .eq('id', studentId)
        .single();

    if (studentError) {
        return NextResponse.json({ error: studentError.message }, { status: 404 });
    }

    // Fetch projects
    const { data: projects, error: projectsError } = await supabase
        .from('projects')
        .select('*')
        .eq('student_id', studentId);

    if (projectsError) {
        return NextResponse.json({ error: projectsError.message }, { status: 500 });
    }

    // Fetch testimonials
    const { data: testimonials, error: testimonialsError } = await supabase
        .from('social_testimonials')
        .select('*')
        .eq('student_id', studentId);

    if (testimonialsError) {
        return NextResponse.json({ error: testimonialsError.message }, { status: 500 });
    }

    return NextResponse.json({
        student,
        projects,
        testimonials
    });
}
