// controllers/movieController.js
const movieService = require('../services/movieService');

const getMovies = (req, res) => {
  const movies = movieService.getAllMovies();
  res.json(movies);
};

module.exports = {
  getMovies
};
