# LCDShopping

Full Stack Shopping App base on Amazon along with Admin Panel
The app is under heavy development

## Current Features
- Email & Password Authentication
- Edit User Information (Name, Email, Address, Avatar)
- Persisting Auth State
- Searching Products
- Filtering Products (Based on Category)
- Product Details
- Rating
- Getting Deal of the Day
- Cart
- Checking out with Google/Apple Pay
- Viewing My Orders
- Viewing Order Details & Status
- Sign Out
- Admin Panel
    - Viewing All Products
    - Filter Products by Category
    - Adding Products
    - Editing Products
    - Deleting Products
    - Viewing All Orders
    - Filter Orders By Status
    - Changing Order Status
    - Viewing Total Earnings
    - Viewing Category Based Earnings (on Graph)


## Running Locally
After cloning this repository, migrate to ```flutter-amazon-clone-tutorial``` folder. Then, follow the following steps:
- Create MongoDB Project & Cluster
- Click on Connect, follow the process where you will get the uri.
- Head to ```lib/constants/global_variables.dart``` file, replace <yourip> with your IP Address. 
- Create Cloudinary Project, enable unsigned operation in settings.
- Config environment files:
  - .env: 
```
CLOUD_NAME=
UPLOAD_PRESET=
API_KEY=
API_SECRET=
```
 - server/.env: Your database uri
```
DB=
```

Then run the following commands to run your app:

### Server Side
```bash
  cd server
  npm install
  npm run dev (for continuous development)
  OR
  npm start (to run script 1 time)
```

### Client Side
```bash
  open your emulator device
  flutter pub get
  flutter run
```

## Tech Used
**Server**: Node.js, Express, Mongoose, MongoDB, Cloudinary

**Client**: Flutter, Provider
    
## Feedback

If you have any feedback, please reach out to me at dat13102k2@gmail.com
