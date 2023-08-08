# LCD-Shopping

- Full Stack Shopping App base on Amazon along with Admin Panel
- The app is under heavy development

## Current Features
- Email & Password Authentication
- Edit User Information (Name, Email, Address, Avatar)
- Persisting Auth State
- Searching Products
- Filtering Products (Based on Category)
- Product Details
- Rating with Review
- View All Reviews
- Filtering Reviews
- Getting Deal of the Day
- Cart
- Checking out with Google/Apple Pay
- Viewing My Orders
- Viewing Order Details & Status
- Sign Out
- Admin Panel
    - Viewing All Products
    - Filtering Products by Category
    - Adding Products
    - Editing Products
    - Deleting Products
    - Viewing All Orders
    - Filtering Orders By Status
    - Changing Order Status
    - Viewing Total Earnings
    - Viewing Category Based Earnings (on Graph)


## Running Locally
After cloning this repository, migrate to ```LCD-Shopping``` folder. Then, follow the following steps:
- Create MongoDB Project & Cluster
- Click on Connect, follow the process where you will get the uri.
- Head to ```lib/constants/global_variables.dart``` file, replace <yourip> with your IP Address. 
- Create Cloudinary Project, enable unsigned operation in settings.
- Config environment files:
  - .env: Cloudinary config
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

## Screenshots

|  	|  	|  	|  	|  	|
|---	|---	|---	|---	|---	|
| ![Screenshot_1691487411](https://github.com/Dat-TG/LCD-Shopping/assets/83936894/22047e09-777d-46a1-bd48-f75620a7bf17) | ![Screenshot_1691487512](https://github.com/Dat-TG/LCD-Shopping/assets/83936894/821f93da-4780-462d-acb1-9d96d92d090e) | ![Screenshot_1691487526](https://github.com/Dat-TG/LCD-Shopping/assets/83936894/f36f2575-8a30-43d2-9778-3c368161c42e) | ![Screenshot_1691487536](https://github.com/Dat-TG/LCD-Shopping/assets/83936894/8960e338-c743-48b7-b8c0-9bcb820df4d0) | ![Screenshot_1691487544](https://github.com/Dat-TG/LCD-Shopping/assets/83936894/7068a13f-7222-4bae-a6a1-50d8e82cf54b) |
|  ![Screenshot_1691487555](https://github.com/Dat-TG/LCD-Shopping/assets/83936894/84ab236b-833f-43f1-8b70-2b1a055206ad) |  ![Screenshot_1691487570](https://github.com/Dat-TG/LCD-Shopping/assets/83936894/47b0a123-9e99-4e04-9757-313d79911bc8) |  ![Screenshot_1691487574](https://github.com/Dat-TG/LCD-Shopping/assets/83936894/893056e0-0fb3-4731-a689-7839b467b45d) |  ![Screenshot_1691487589](https://github.com/Dat-TG/LCD-Shopping/assets/83936894/1fa15f1d-a16a-48c2-b5ed-82b2540e4ae3) |  ![Screenshot_1691487612](https://github.com/Dat-TG/LCD-Shopping/assets/83936894/f52552aa-fd56-4145-b3be-59f8d23437e8) |
|  ![Screenshot_1691487618](https://github.com/Dat-TG/LCD-Shopping/assets/83936894/9c0a0b69-a0da-434d-8444-7f4e347d7269) |  ![Screenshot_1691487641](https://github.com/Dat-TG/LCD-Shopping/assets/83936894/0011ae6a-6722-4e7f-99a1-95c873089fc3) |  ![Screenshot_1691487656](https://github.com/Dat-TG/LCD-Shopping/assets/83936894/61de3d96-12cc-4551-a0a9-ddfa983b0a3e) |  ![Screenshot_1691487664](https://github.com/Dat-TG/LCD-Shopping/assets/83936894/a0d8cad8-34aa-4375-b72e-ef1b065a3001) |  ![Screenshot_1691487678](https://github.com/Dat-TG/LCD-Shopping/assets/83936894/7da9b6af-127b-4217-b484-e067ea9ce5ad) |
|   ![Screenshot_1691487683](https://github.com/Dat-TG/LCD-Shopping/assets/83936894/a92f2343-bbd8-4bfd-9692-7e3358865e9e) | ![Screenshot_1691487705](https://github.com/Dat-TG/LCD-Shopping/assets/83936894/cd1259b8-281f-4a20-9f98-0a69ad3889a8) | ![Screenshot_1691487749](https://github.com/Dat-TG/LCD-Shopping/assets/83936894/91d85ea2-29f1-45e3-945b-f23fa0b759c4) | ![Screenshot_1691488090](https://github.com/Dat-TG/LCD-Shopping/assets/83936894/eccbf5af-db0c-4735-b433-23fad4591dc6) | ![Screenshot_1691488097](https://github.com/Dat-TG/LCD-Shopping/assets/83936894/d9270614-0dc6-42ba-813d-ee0b4ec209e8) |
|  ![Screenshot_1691488105](https://github.com/Dat-TG/LCD-Shopping/assets/83936894/8d9236a8-9b59-401a-90c8-eb41b93aee37) | ![Screenshot_1691488113](https://github.com/Dat-TG/LCD-Shopping/assets/83936894/59c70ae3-7264-4479-a827-9b95c69fb764) |  ![Screenshot_1691488121](https://github.com/Dat-TG/LCD-Shopping/assets/83936894/5a3f37a6-c0f6-42cf-8336-faaa44f55d16) |![Screenshot_1691488135](https://github.com/Dat-TG/LCD-Shopping/assets/83936894/f0daef36-494c-41b2-bed7-dd5969131e45) | ![Screenshot_1691488137](https://github.com/Dat-TG/LCD-Shopping/assets/83936894/cc41c269-862d-4c57-a02b-ef8148ee72a2) |
