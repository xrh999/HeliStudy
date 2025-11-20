//
//  Supabase.swift
//  Best Study App
//
//  Created by Huang XR on 25/9/25.
//

import Supabase
import Foundation

let supabase = SupabaseClient(supabaseURL: URL(string: "https://phozqzcgihcqdyjnfuce.supabase.co")!,  supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBob3pxemNnaWhjcWR5am5mdWNlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTg2Mjg5MTEsImV4cCI6MjA3NDIwNDkxMX0.z5thSdhfy5-z9CciouLQeDK_rEIJNdFFHRpQd5X__qk")

struct Time: Decodable, Identifiable {
    let userID: String
    let time: Int
    
    var id: String{ userID }
}

