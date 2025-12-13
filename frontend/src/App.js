import React, { useState } from "react";

function App() {
  const [form, setForm] = useState({ name: "", email: "", message: "" });
  const [apps, setApps] = useState([]);

  const handleChange = (e) => {
    setForm({ ...form, [e.target.name]: e.target.value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    await fetch("/api/apply", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(form),
    });
    alert("Application submitted!");
    loadApps();
  };

  const loadApps = async () => {
    const res = await fetch("/api/applications");
    const data = await res.json();
    setApps(data);
  };

  return (
    <div style={{ padding: "20px" }}>
      <h1>User Application Form</h1>
      <form onSubmit={handleSubmit}>
        <input name="name" placeholder="Name" onChange={handleChange} /><br />
        <input name="email" placeholder="Email" onChange={handleChange} /><br />
        <textarea name="message" placeholder="Message" onChange={handleChange} /><br />
        <button type="submit">Submit</button>
      </form>

      <h2>Submitted Applications</h2>
      <button onClick={loadApps}>Refresh</button>
      <ul>
        {apps.map(a => (
          <li key={a.id}>{a.name} - {a.email} - {a.message}</li>
        ))}
      </ul>
    </div>
  );
}

export default App;
