const express = require('express');
const cors = require('cors');
const db = require('./db');
const app = express();

app.use(cors());
app.use(express.json());

// إنشاء الجدول لو مش موجود
db.query(`
  CREATE TABLE IF NOT EXISTS contact_messages (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    message TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  )
`);

// استقبال نموذج التواصل
app.post('/api/contact', (req, res) => {
  const { name, email, message } = req.body;
  if (!name || !email || !message) {
    return res.status(400).json({ error: 'Missing fields' });
  }

  db.query(
    'INSERT INTO contact_messages (name, email, message) VALUES (?, ?, ?)',
    [name, email, message],
    (err) => {
      if (err) {
        console.error(err);
        return res.status(500).json({ error: 'Database error' });
      }
      res.json({ success: true, message: 'Message saved successfully!' });
    }
  );
});

app.listen(5000, () => console.log('🚀 Backend running on port 5000'));
