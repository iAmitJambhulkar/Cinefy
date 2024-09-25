// services/movieService.js
const movieModel = require('../models/movieModel');

const getAllMovies = () => {
  return movieModel.loadMovies();
};

module.exports = {
  getAllMovies
};
