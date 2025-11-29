import { createClient } from '@/utils/supabase/server';
import { NextResponse } from 'next/server';

export async function GET() {
    const supabase = createClient();

    const { data, error } = await supabase
        .from('social_testimonials')
        .select('*')
        .limit(10); // Limit for social card

    if (error) {
        return NextResponse.json({ error: error.message }, { status: 500 });
    }

    return NextResponse.json({ testimonials: data });
}
