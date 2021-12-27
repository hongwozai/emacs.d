;;-------------------------------------------
;;; custom project
;;-------------------------------------------
(projectile-register-project-type
 'mycmake '("CMakeLists.txt" "src")
 :compile "cmake -H. -Bbuild && cmake --build build --parallel"
 :test "cmake -H. -Bbuild && cmake --build build --target test"
 :test-prefix "test_"
 )