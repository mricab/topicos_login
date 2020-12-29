<?php

namespace App\Http\Controllers;
use Illuminate\Http\Request;
use Validator;
use App\Models\User;
use Auth;


class UsersController extends Controller
{
    public function login()
    {
        if (Auth::attempt(['email' => request('email'), 'password' => request('password')])) {
            $user = Auth::user();
            $user['photo'] = str_replace('public', 'http://localhost:8000/storage', $user['photo']);
            $success['token'] = $user->createToken('appToken')->accessToken;
           //After successfull authentication
            return response()->json([
              'success' => true,
              'token' => $success,      //the auth token generated from passport
              'user' => $user           //an instance of the authenticated user created.
            ]);
        } else {
          //if authentication is unsuccessfull
          return response()->json([
            'success' => false,
            'message' => 'Invalid Email or Password',
          ], 401);
        }
    }

    /**
     * Register api.
     *
     * @return \Illuminate\Http\Response
     */
    public function register(Request $request)
    {
      //Validation of all fields
      $validator = Validator::make($request->all(), [
          'fname' => 'required',
          'lname' => 'required',
          'address' => 'required',
          'phone' => 'required|unique:users|regex:/(0)[0-9]{10}/',
          'photo' => 'required',
          'email' => 'required|email|unique:users',
          'password' => 'required',
      ]);
      if ($validator->fails()) {
        return response()->json([
          'success' => false,
          'message' => $validator->errors(),
        ], 401);
      }

      //Validation of photo: Verification of presence
      if(!$request->hasFile('photo')) {
        return response()->json([
          'success' => false,
          'message' => 'upload_file_not_found',
        ], 400);
      }

      //Validation of photo: Verification of file type
      $allowedfileExtension=['jpg','jpeg','png'];
      $file = $request->file('photo');
      $errors = [];

      $extension = $file->getClientOriginalExtension();  
      $check = in_array($extension,$allowedfileExtension);
      if(!$check) {
        return response()->json([
          'success' => false,
          'message' => 'invalid_file_format',
        ], 422);
      }

      // Store photo
      $path = $file->store('public/images');

      // Store user
      $input = $request->all();
      $input['password'] = bcrypt($input['password']);
      $input['photo'] = $path;
      $user = User::create($input);
      $success['token'] = $user->createToken('appToken')->accessToken;
      return response()->json([
        'success' => true,
        'token' => $success,
        'user' => $user
      ]);
    }


    public function logout(Request $res)
    {
      if (Auth::user()) {
        $user = Auth::user()->token();
        $user->revoke();

        return response()->json([
          'success' => true,
          'message' => 'Logout successfully'
      ]);
      }else {
        return response()->json([
          'success' => false,
          'message' => 'Unable to Logout'
        ]);
      }
    }    
};