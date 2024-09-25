// models/movieModel.js
const fs = require('fs');
const path = require('path');

// Load movie data from JSON file
const moviesPath = path.join(__dirname, '../db/movies.json');

const loadMovies = () => {
  const data = fs.readFileSync(moviesPath);
  return JSON.parse(data);
};

module.exports = {
  loadMovies
};
