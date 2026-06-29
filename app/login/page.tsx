import "./login.css";

export default function LoginPage() {
  return (
    <main className="loginPage">
      <section className="loginFrame">
        <div className="loginBrand">
          <h1>RAPYARD</h1>
          <p>WHERE BARS GET BUILT</p>
        </div>

        <form className="loginPanel">
          <h2>Sign In</h2>

          <label>
            <span>👤</span>
            <input type="email" placeholder="Email" />
          </label>

          <label>
            <span>🔒</span>
            <input type="password" placeholder="Password" />
          </label>

          <button type="submit">SIGN IN</button>

          <a href="#" className="forgot">
            Forgot password?
          </a>

          <p className="join">
            New to the Yard? <a href="/signup">Join Now</a>
          </p>
        </form>
      </section>
    </main>
  );
}