import express from 'express';
import cors from 'cors';
import PocketBase from 'pocketbase';
import fs from 'fs';
import { parse } from 'csv';
import multer from 'multer';

const app = express();
app.use(cors());
app.use(express.json());

const pb = new PocketBase('https://attendease.fly.dev');
const resultList = await pb.collection('students').getList(1, 50, {
  filter: 'name = ' + `"${"Stephen Vaz"}"`,
});
// returns result of attendance of a student (first) resultList["items"][0]["attendance"]
// returns result of id of a student (first) resultList["items"][0]["id"]
console.log(resultList["items"][0]["id"]);

//used to store the csv file
var temp = "" //holds the name of the csv file
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, 'uploads/')
  },
  filename: function (req, file, cb) {
    temp = file.originalname
    cb(null, file.originalname)
  }
});
const upload = multer({ storage: storage });
//listen port 3000
app.listen(3000, () => {
  console.log(`Server started on port http://localhost:3000`);
});

//upload csv file
app.post('/upload', upload.single('file'), (req, res) => {
  temp = temp.split('.')[0];
  console.log(temp);
  console.log('CSV file uploaded');
  var path = "./uploads/" + temp;
  console.log(path);
  //read csv file
  fs.readFile(path + ".csv", 'utf-8', (err, dp) => {
    if (err) throw err;
    parse(dp, { columns: true }, async function (err, data) {
      if (err) throw err
      console.log(data)
      //loop through the csv file
      var resultList = {}
      for (var i = 0; i < data.length; i++) {
        //loop through the csv file and find the id from the name from pocketbase
        //console.log('name = ' + `"${data[i].Name}"`)
        resultList = await pb.collection('students').getList(1, 50, {
          filter: 'name = ' + `"${data[i].Name}"`,
        })
        //delete from pb using id
        console.log(resultList["items"][0]["id"])
        //await pb.collection('students').delete(resultList["items"][0]["id"])

        var temp2 = resultList["items"][0]["attendance"][temp];
        temp2.push(data[i].join)
        //console.log("temp2")
        //console.log(temp2)
        resultList["items"][0].password = "12345678"
        resultList["items"][0].passwordConfirm = "12345678"
        resultList["items"][0].oldPassword = "87654321"
        var temp3 = resultList
        //console.log(temp3)
        temp3["items"][0]["attendance"][temp] = temp2
        var temp4 = temp3["items"][0]
        //console.log(temp4)
        const final = {
          "attendance": temp4["attendance"],
      };
      
        //insert the attendance of the student using the resultList
        await pb.collection('students').update(resultList["items"][0]["id"] ,final);
      }
      
    });
  });

  res.sendStatus(200);
});

app.get('/', (req, res) => {
  res.send('AttendWise Homepage');
});

app.get("/qr/:id", async (req, res) => {
  try{
  console.log(req.params.id);
  const data = {
    "encrypted_string": req.params.id,
};
const record = await pb.collection('rohantest').update('959gfscofc4dyw0', data);
res.sendStatus(200);
  } catch (err) {
    console.log(err);
  }
});