// server.js
const express = require('express');
const cors = require('cors');
const movieController = require('./controller/movieController');


const app = express();
const PORT = process.env.PORT || 3000;

// Enable CORS
app.use(cors());

// Define routes
app.get('/api/movies', movieController.getMovies);

// Start the server
app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});
