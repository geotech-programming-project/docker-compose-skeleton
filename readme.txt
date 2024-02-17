



ssh-keygen -t rsa -b 4096 -C "guilhermeviegas1993@gmail.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
xclip -sel clip < ~/.ssh/id_rsa.pub    # Copy your SSH public key to the clipboard
ssh -T git@github.com


SELECT column_name
FROM information_schema.columns
WHERE table_name = 'your_table';
