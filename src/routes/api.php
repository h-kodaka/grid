<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Models\User;

Route::get('/users', function () {
    $users = User::select('id', 'name', 'email', 'phone_number', 'mobile_number', 'address', 'created_at', 'updated_at')->get();
    return $users->map(function (User $user) {
        return [
            'id' => $user->id,
            'name' => $user->name,
            'email' => $user->email,
            'phone_number' => $user->phone_number,
            'mobile_number' => $user->mobile_number,
            'address' => $user->address,
            'created_at' => $user->created_at->format('Y-m-d H:i:s'),
            'updated_at' => $user->updated_at->format('Y-m-d H:i:s'),
        ];
    });
});

Route::patch('/users', function (Request $request) {
    $users = $request->input('users');
    
    foreach ($users as $userData) {
        $user = User::find($userData['id']);
        if ($user) {
            $user->fill([
                'name' => $userData['name'],
                'email' => $userData['email'],
                'phone_number' => $userData['phone_number'],
                'mobile_number' => $userData['mobile_number'],
                'address' => $userData['address'],
            ])->save();
        }
    }
    
    return response()->json();
});
