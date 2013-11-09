module.exports =
  
  NODE_ENV: 'development'
  PORT: 3001
  API_URL: 'http://localhost:3000'
  PRICES: [800, 1000, 1200, 1400, 1600, 1800, 2000, 2200, 2400, 2600, 2800, 3000, 3500, 
           4000, 4500, 5000, 6000, 7000, 8000, 9000, 10000]
  MANDRILL_KEY: 'GWpTZdC5VKXaNf6VReRz5w'
  MIXPANEL_KEY: '43b61ce4f9ba26bc8e87d44568af0622'
  
# Override any values with env variables if they exist
module.exports[key] = (process.env[key] or val) for key, val of module.exports