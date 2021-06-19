Following is the standard Role directory structure recommended by Ansible. You can omit unused folders from the actual implementation.

dev.yml
test.yml
prod.yml
roles/
    [role-name]/
        tasks/
        handlers/
        library/
        files/
        templates/
        vars/
        defaults/
        meta/
