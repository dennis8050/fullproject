import React, { useState, useEffect } from "react";

function App() {
  const [form, setForm] = useState({ name: "", email: "", message: "" });
  const [apps, setApps] = useState([]);
  const [loading, setLoading] = useState(false);

  const handleChange = (e) => {
    setForm({ ...form, [e.target.name]: e.target.value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);

    await fetch("/api/apply", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(form),
    });

    setForm({ name: "", email: "", message: "" });
    setLoading(false);
    loadApps();
  };

  const loadApps = async () => {
    const res = await fetch("/api/applications");
    const data = await res.json();
    setApps(data);
  };

  useEffect(() => {
    loadApps();
  }, []);

  return (
    <div className="container">
      <div className="card shadow-lg p-4">
        <h2 className="text-center mb-4">User Application Form</h2>

        <form onSubmit={handleSubmit}>
          <div className="mb-3">
            <label className="form-label">Name</label>
            <input
              className="form-control"
              name="name"
              value={form.name}
              onChange={handleChange}
              placeholder="Enter your name"
              required
            />
          </div>

          <div className="mb-3">
            <label className="form-label">Email</label>
            <input
              type="email"
              className="form-control"
              name="email"
              value={form.email}
              onChange={handleChange}
              placeholder="Enter your email"
              required
            />
          </div>

          <div className="mb-3">
            <label className="form-label">Message</label>
            <textarea
              className="form-control"
              name="message"
              value={form.message}
              onChange={handleChange}
              placeholder="Write your message"
              rows="4"
              required
            />
          </div>

          <button className="btn btn-primary w-100" disabled={loading}>
            {loading ? "Submitting..." : "Submit Application"}
          </button>
        </form>
      </div>

      <div className="card shadow mt-4 p-4">
        <div className="d-flex justify-content-between align-items-center mb-3">
          <h4 className="mb-0">Submitted Applications</h4>
          <button className="btn btn-outline-secondary btn-sm" onClick={loadApps}>
            Refresh
          </button>
        </div>

        {apps.length === 0 ? (
          <p className="text-muted">No applications yet.</p>
        ) : (
          <ul className="list-group">
            {apps.map((a) => (
              <li key={a.id} className="list-group-item">
                <strong>{a.name}</strong>
                <div className="text-muted">{a.email}</div>
                <div>{a.message}</div>
              </li>
            ))}
          </ul>
        )}
      </div>
    </div>
  );
}

export default App;
