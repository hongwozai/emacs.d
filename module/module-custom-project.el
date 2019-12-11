;;-------------------------------------------
;;; custom project
;;-------------------------------------------
(projectile-register-project-type
 'mycmake '("CMakeLists.txt" "src")
 :compile "cmake -H. -Bbuild && make -C build"
 :test "cmake -H. -Bbuild && make -C build test"
 :test-prefix "test_"
 )