import API from 'janosh.js';
import config from './config';

var api = new API(config.socketUri);

export default api;
