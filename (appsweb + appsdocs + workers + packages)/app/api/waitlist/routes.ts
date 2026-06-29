import { NextResponse } from "next/server";

export async function POST(req: Request) {
  const { email } = await req.json();

  // TODO:
  // Save to your database
  // Send SES welcome email
  // Increment founder count

  return NextResponse.json({
    success: true,
    email,
  });
}