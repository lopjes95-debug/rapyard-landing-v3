import "./globals.css"
import { createClient } from "@/lib/supabase/server"

export default async function RootLayout({ children }) {
  const supabase = createClient()
  const { data: { user } } = await supabase.auth.getUser()

  return (
    <html lang="en">
      <body>
        {children}
      </body>
    </html>
  )
}
