<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ClientLog extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id', 
        'action', 
        'type', 
        'record_id',
        'original_date',
        'description',
        'program' // Directly store the program ID here (from allocation or utilization)
    ];

    // Relation to the User model
    public function user()
    {
        return $this->belongsTo(User::class, 'user_id');
    }

    // Relation to Allocation, assuming 'record_id' refers to the Allocation ID
    public function allocation()
    {
        return $this->hasOne(Allocation::class, 'id', 'record_id');
    }

    // Relation to Utilization, assuming 'record_id' refers to the Utilization ID
    public function utilization()
    {
        return $this->hasOne(Utilization::class, 'id', 'record_id');
    }

    public function program()
    {
        return $this->belongsTo(Program::class, 'program'); // 'program' should refer to the foreign key in `client_logs`
    }
}