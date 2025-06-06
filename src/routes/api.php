<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Models\User;

Route::get('/users', function () {
    return User::select('id', 'name', 'email', 'created_at', 'updated_at')->get();
});
