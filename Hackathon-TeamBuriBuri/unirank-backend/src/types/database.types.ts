export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export interface Database {
  public: {
    Tables: {
      students: {
        Row: {
          id: string
          auth_id: string | null
          name: string | null
          email: string | null
          avatar_url: string | null
          college: string | null
          branch: string | null
          year: number | null
          pro_score: number
          social_score: number
          attendance: number
          gpa: number
          skills: string[]
          lc_id: string | null
          cf_id: string | null
          cc_id: string | null
          github_username: string | null
          created_at: string
        }
        Insert: {
          id?: string
          auth_id?: string | null
          name?: string | null
          email?: string | null
          avatar_url?: string | null
          college?: string | null
          branch?: string | null
          year?: number | null
          pro_score?: number
          social_score?: number
          attendance?: number
          gpa?: number
          skills?: string[]
          lc_id?: string | null
          cf_id?: string | null
          cc_id?: string | null
          github_username?: string | null
          created_at?: string
        }
        Update: {
          id?: string
          auth_id?: string | null
          name?: string | null
          email?: string | null
          avatar_url?: string | null
          college?: string | null
          branch?: string | null
          year?: number | null
          pro_score?: number
          social_score?: number
          attendance?: number
          gpa?: number
          skills?: string[]
          lc_id?: string | null
          cf_id?: string | null
          cc_id?: string | null
          github_username?: string | null
          created_at?: string
        }
      }
      projects: {
        Row: {
          id: string
          student_id: string | null
          title: string | null
          description: string | null
          repo_url: string | null
          created_at: string
        }
        Insert: {
          id?: string
          student_id?: string | null
          title?: string | null
          description?: string | null
          repo_url?: string | null
          created_at?: string
        }
        Update: {
          id?: string
          student_id?: string | null
          title?: string | null
          description?: string | null
          repo_url?: string | null
          created_at?: string
        }
      }
      social_testimonials: {
        Row: {
          id: string
          student_id: string | null
          quote: string | null
          designation: string | null
          image_url: string | null
          created_at: string
        }
        Insert: {
          id?: string
          student_id?: string | null
          quote?: string | null
          designation?: string | null
          image_url?: string | null
          created_at?: string
        }
        Update: {
          id?: string
          student_id?: string | null
          quote?: string | null
          designation?: string | null
          image_url?: string | null
          created_at?: string
        }
      }
      leaderboard_cache: {
        Row: {
          id: number
          college: string | null
          top_students: Json | null
          updated_at: string
        }
        Insert: {
          id?: number
          college?: string | null
          top_students?: Json | null
          updated_at?: string
        }
        Update: {
          id?: number
          college?: string | null
          top_students?: Json | null
          updated_at?: string
        }
      }
    }
  }
}
