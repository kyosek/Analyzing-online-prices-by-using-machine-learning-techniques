## load data
df <- fread("~/usa.csv")

# logistic regression
model <- speedglm(event ~ duration + day +weekofm +  month +
                    fullprice +pricecat+ category,
                  data = df,
                  family = binomial(link = "logit"), maxit = 50)
summary(model)

#### firth ####
# Elastic Net
firthe = logistf(event ~ duration + fullprice+ cat531,
                 data=df)
summary(firthe)

firth = logistf(event ~ duration + fullprice,
                data=df)
summary(firth)

anova(firth,firthe)