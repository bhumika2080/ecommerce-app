package com.kotlin.kotlinapp

import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.fragment.app.Fragment
import com.kotlin.kotlinapp.databinding.FragmentLoginBinding
import java.util.UUID

class LoginFragment : Fragment() {

    private var _binding: FragmentLoginBinding? = null
    private val binding get() = _binding!!

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        _binding = FragmentLoginBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        binding.loginButton.setOnClickListener {
            val username = binding.username.text.toString()
            val password = binding.password.text.toString()

            if (username.isNotEmpty() && password.isNotEmpty()) {
                val uuid = UUID.randomUUID().toString()

                val sharedPref = requireActivity().getSharedPreferences("AppPrefs", Context.MODE_PRIVATE)
                with(sharedPref.edit()) {
                    putString("cached_uuid", uuid)
                    apply()
                }

                val intent = Intent(requireContext(), FlutterBridgeActivity::class.java)
                startActivity(intent)

                Toast.makeText(context, "Login successful! UUID: ${uuid.take(8)}...", Toast.LENGTH_SHORT).show()
            } else {
                Toast.makeText(context, "Please enter username and password", Toast.LENGTH_SHORT).show()
            }
        }
    }

    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }
}
