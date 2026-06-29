import type { SupabaseClient } from "@supabase/supabase-js"
import { json } from "../lib/responses"

export async function handleMe(supabase: SupabaseClient, user: any) {
  // user is decoded JWT payload from withSupabase (auth: "user")
  return json({ user })
}
