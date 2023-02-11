import Head from 'next/head'
import Image from 'next/image'
import Link from 'next/link'
// for authentication
import { auth, firestore } from './firebase'
import { signInWithPopup, GoogleAuthProvider, getAuth, multiFactor } from 'firebase/auth'
import { async } from '@firebase/util';
import { useAuthState } from "react-firebase-hooks/auth";
import { useState, useEffect } from 'react';
import { getDoc, doc, setDoc } from 'firebase/firestore'

// for firestore



export default function Home() {

  // for authentication
  const [user, setuser] = useAuthState(auth);
  const googleAuth = new GoogleAuthProvider();
  const login = async () => {
    const result = await signInWithPopup(auth, googleAuth);
    

  }

  


  // for firestore



  const special = doc(firestore, 'accounts/2abhishek00roka2@gmail.com/2023-02-15/2023-02-15');
  const special2 = doc(firestore, 'accounts/2abhishek00roka2@gmail.com/2023-02-17/2023-02-17')

  // reading from firestore
  // async function readASingleDocument() {
  //   const mySnapshot = await getDoc(special);
  //   if (mySnapshot.exists()){
  //     const docData = mySnapshot.data();
  //     console.log(`My data is ${JSON.stringify(docData)}`);
  //   }

  // }
  // // readASingleDocument()

  // //writing to firestore
  // function writeData() {
  //   const docData = {
  //     0:{
  //     name: "milk",
  //     cost: 68.48
  //   },
  //   1:{
  //     name:"vegen",
  //     cost:"100"
  //   },
  //   2:{
  //     name:"water",
  //     cost:"40"
  //   }

  //   };
  //   setDoc(special2,docData,{merge: true});

  // }

  // writeData();



  // new document in collections

  async function addANewDocument() {
    
  }

  // All code of account table
  let sumTotal = 0;
  const list = []
  const [total, newtotal] = useState(0);






  const showChange = (e) => {
    // console.log(e.target.value);
  }




  //Serious code

  //reset record
  const reset = () => {
    list.splice(0, list.length);

    document.getElementById("expenseListDiv").innerHTML = "";
    // let count = 0;

    // for (let index = 0; index < list.length; index++) {
    //   document.getElementById("expenseListDiv").innerHTML += `<div class='grid grid-cols-2 gap-2 border  border-black ' id="${index}">
                
    //             <p  class=" text-center">${list[index][0]}</p>
    //             <p class=" text-center">${list[index][1]}</p>

    //             <div class='m-2'>
                
    //             <button  class='bg-red-900 text-white font-bold text-md px-4 py-2 rounded-md border-2 border-black hover:bg-red-600'>Delete</button>
    //         </div>
    //             </div>`

    // }
  }


  //reprinting list
  function showList() {

    useEffect(() => {
      document.getElementById("expenseListDiv").innerHTML = "";
      let count = 0;

      if (user != null) {

        for (let index = 0; index < list.length; index++) {
          sumTotal += list[index][1];
          newtotal(sumTotal);
          document.getElementById("expenseListDiv").innerHTML += `<div class='grid grid-cols-2 gap-2 border  border-black ' id="${index}">
                    
                    <p  class=" text-center">${list[index][0]}</p>
                    <p class=" text-center">${list[index][1]}</p>         
                    
                   
                    </div>`

        }
      }

    });

  }

  showList();
  // To Add Record
  const [addName, newaddName] = useState("");
  const [addcost, newaddCost] = useState(0);

  const addRecord = (e) => {
    e.preventDefault();

    for (let index = 0; index < list.length; index++) {
      // console.log(list[index][0]);
      if (list[index][0] == addName) {
        alert("Record already exists!");
        return;
      }
    }
    let name = addName;
    let cost = Number(addcost);
    list.push([name, cost]);
    sumTotal+=cost;
    newtotal(sumTotal);
    // console.log(list);
    alert("Recorded Added!");

    document.getElementById("expenseListDiv").innerHTML = "";
    

    for (let index = 0; index < list.length; index++) {
      document.getElementById("expenseListDiv").innerHTML += `<div class='grid grid-cols-2 gap-2 border  border-black ' id="${index}">
                
                <p  class=" text-center">${list[index][0]}</p>
                <p class=" text-center">${list[index][1]}</p>

                
                </div>`

    }



  }


  return (
    <>
      <main>
        {/* <Link href="/accounTable">To AccounTable</Link> */}
        <div className='text-center text-violet-500'>
          <h1>To Get Started, You Need to Login with Google!</h1>
          {user ? <button id="logout" onClick={() => auth.signOut()} className='border-2 border-black' >Log Out</button> : 
          <button id="login" className='border-2 border-black' onClick={login}>Log In</button>}

          
          <div >
            {user ? "Welcome, " + user.displayName : ""}
            
          </div>
        </div>

        <section className=''>
          <div className='flex justify-center'>
            <div>
              <div>
                <p className='text-center'>Choose Date</p>
              </div>
              <div>
                <input onChange={showChange} className='align-text-top' type="date" name="date" id="date" />
              </div>
            </div>
          </div>



          <div className='flex justify-center'>
            <div className='border border-black w-1/2'>
              <div className='grid grid-cols-2 gap-2 border '>
                <div>
                  <p className='text-center font-bold'>Expense on</p>
                </div>
                <div>
                  <p className='text-center font-bold'>Expense in Rs.</p>
                </div>

              </div>


              {/* Scrollable table body */}
              <div className="h-60 overflow-auto" id="expenseListDiv">
              </div>

              {/* Footer */}
              <div className='grid grid-cols-2 gap-2 border  border-black'>
                <div>
                  <p>
                    Total
                  </p>
                </div>
                <div>
                  <p>
                    {total}
                  </p>
                </div>
              </div>
            </div>




          </div>
          <div className='flex flex-row justify-center my-4'>
            <button className='bg-purple-900 text-white font-bold text-lg px-4 py-2 rounded-md border-2 border-black hover:bg-purple-600'>Submit</button>
            <button onClick={reset} className='bg-red-900 text-white font-bold text-lg px-4 py-2 rounded-md border-2 border-black hover:bg-red-600 mx-2'>Reset</button>

          </div>


          {/* //Add Adder */}
          <div className='flex flex-row flex-wrap justify-center'>
            <div>

              <div>
                <p className='text-center'>Add Record here:-</p>

              </div>
              <form >
                <input value={addName} onChange={(e) => { newaddName(e.target.value) }} type="text" placeholder='Expense Goes here...' />
                <input value={addcost} onChange={(e) => { newaddCost(e.target.value) }} type="number" placeholder='Expense value goes here...' />
                <button onClick={addRecord} className='bg-red-500 text-white font-bold text-lg px-2 py-1 rounded-md border-2 border-black hover:bg-red-900'>Add</button>
              </form>
            </div>
          </div>




        </section>



      </main>
    </>
  )
}
