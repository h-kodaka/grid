<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Models\User;

Route::get('/users', function () {
    $users = User::select('id', 'name', 'email', 'created_at', 'updated_at')->get();
    return $users;
});

Route::patch('/users', function (Request $request) {
    // 一括更新
});
