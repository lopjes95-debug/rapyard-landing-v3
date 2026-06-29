export default {
  async fetch() {
    return new Response(`
<!DOCTYPE html>
<html>
<head>
<title>RapYard</title>
<style>
body{
background:#050505;
color:white;
font-family:Arial;
display:flex;
justify-content:center;
align-items:center;
height:100vh;
margin:0;
}
.container{
text-align:center;
max-width:600px;
}
input,button{
width:100%;
padding:16px;
margin-top:10px;
border-radius:12px;
border:none;
}
</style>
</head>
<body>
<div class="container">
<h1>RAPYARD</h1>
<p>Join the waitlist.</p>
<input type="email" placeholder="Enter your email">
<button>Join Waitlist</button>
</div>
</body>
</html>
`, {
      headers: {
        "content-type": "text/html"
      }
    });
  }
}