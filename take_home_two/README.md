# deploy the test application
`kubectl apply -f k8s_config/` and run `kubectl port-forward service/web 9090:9090 --address 0.0.0.0 -n web-app` to access the site

# To access the consul UI use
`http://(consul-ui service external-ip)`
To get the external ip run 
`kubectl get svc -n consul`

# To access wordpress 
`http://(wordpress service external-ip)/admin`

To get the external ip run 
`kubectl get svc -n wordpress`