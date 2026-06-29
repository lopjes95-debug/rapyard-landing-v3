import type { SupabaseClient } from "@supabase/supabase-js"
import { json, error } from "../lib/responses"

export async function handleTodos(supabase: SupabaseClient) {
  const { data, error: err } = await supabase.from("todos").select("*")

  if (err) return error(err.message, 400)
  return json(data)
}
