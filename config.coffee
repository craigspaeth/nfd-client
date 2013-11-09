module.exports =
  
  NODE_ENV: 'development'
  PORT: 3001
  API_URL: 'http://localhost:3000'
  PRICES: [800, 1000, 1200, 1400, 1600, 1800, 2000, 2200, 2400, 2600, 2800, 3000, 3500, 
           4000, 4500, 5000, 6000, 7000, 8000, 9000, 10000]
  MANDRILL_APIKEY: 'yFJt0L42xBWoJ-xGrE3XWw'
  MIXPANEL_KEY: '43b61ce4f9ba26bc8e87d44568af0622'
  NEW_RELIC_LICENSE_KEY: '8337cb8875421195e07147b39f6d26ff8ab795d3' 
  HERO_UNITS: [
    {
      path: 'http://farm8.staticflickr.com/7216/7165051233_befdd890b8_b.jpg'
      url: 'http://www.flickr.com/photos/jnarber/7165051233/in/photolist-bV9L76-fhEdXi-8RR5BR-7xMBVN-cQwRpN-dkJxg5-djX4sB-azxoTY-azuJFg-azxoB9-7FgPBB-bCa6Zo-afSNR4-8Zq6oa-8Zq6jF-8Zta8s-8ZtabY-euWgxT-dTAJh5-9DUf7b-9DRUox-bWF2AZ-9DT8AH-bHVDEM-9n8VLS-euZn6Y-euWfpi-euZo11-cmw3oo-cmw2Pj-cmvnSC-cmvvB3-cmv6Vw-cmw15b-cmvLVs-cmv8Eh-cmvZyq-cmvapd-cmvL9Y-9DRUyk-9DRSzP-9DZimC-dHLu7j/'
      author: 'Jared Narber'
      pos: 'top'
    }
    {
      path: 'http://farm7.staticflickr.com/6052/6279775284_97cf791721_b.jpg'
      url: 'http://www.flickr.com/photos/edrost88/6279775284/sizes/o/'
      author: 'Erik Drost'
      pos: 'center'
    }
    {
      path: 'http://farm1.staticflickr.com/41/104838613_d2b262878e_b.jpg'
      url: 'http://www.flickr.com/photos/jul/104838613/'
      author: 'Julien Menichini'
      pos: 'center'
    }
    {
      path: 'http://farm4.staticflickr.com/3587/3584915920_1d68337526_o.jpg'
      url: 'http://www.flickr.com/photos/sidelife/3584915920/sizes/o/'
      author: 'Arsenie Coseac'
      pos: 'center'
    }
    {
      path: 'http://farm3.staticflickr.com/2571/4061232914_0241752ed1_b.jpg'
      url: 'http://www.flickr.com/photos/sackerman519/4061232914/'
      author: 'Sarah Ackerman'
      pos: 'bottom'
    }
    {
      path: 'http://farm8.staticflickr.com/7110/7038011669_f822cf6750_b.jpg'
      url: 'http://www.flickr.com/photos/99472898@N00/7038011669/in/photolist-bHVDEM-9n8VLS-euZo11-euWgxT-cmw3oo-cmw2Pj-cmvnSC-9DZimC-arX3XD-arXc5r-arXpfi-arX8iz-arZsou-arZGoo-arZ8ny-arWZpk-arWCJ4-arWSw6-arZwxN-arWGqP-arX71D-arZhDU-arZaSU-arZmcu-9uYc9R-arZWJU-arWzRg-c6p1DN-dTM5oD-avTYLK-7QrmKr'
      author: 'Kenny Louie'
      pos: 'top'
    }
    {
      path: 'http://farm2.staticflickr.com/1390/853546651_41ff333849_b.jpg'
      url: 'http://www.flickr.com/photos/jenniferwoodardmaderazo/853546651/'
      author: 'Jennifer Woodard Maderazo'
      pos: 'bottom'
    }
  ]
  
# Override any values with env variables if they exist
module.exports[key] = (process.env[key] or val) for key, val of module.exports