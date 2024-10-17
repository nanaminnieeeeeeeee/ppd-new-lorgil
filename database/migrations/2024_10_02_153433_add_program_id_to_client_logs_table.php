<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up()
    {
        Schema::table('client_logs', function (Blueprint $table) {
            $table->unsignedBigInteger('program_id')->nullable()->after('user_id'); // Add program ID
        });
    }
    
    public function down()
    {
        Schema::table('client_logs', function (Blueprint $table) {
            $table->dropColumn('program_id');
        });
    }
};
