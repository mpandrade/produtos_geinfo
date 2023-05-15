// script.js



const cardData = [

  {

    id: 1,

    category: "Previne Brasil",

    image: "img/ind123.png",

    title: "Indicadores 1, 2 e 3 do Previne B.",

    description: "Consultas de Pré-Natal e Testes de HIV e Sífilis",

    link: "https://lookerstudio.google.com/u/1/reporting/52ee8dae-a9e6-4a45-a085-def771582f8d/page/p_kxgf0ijvyc",

  },

  {

    id: 2,

    category: "Previne Brasil",

    image: "img/ind4.jpg",

    title: "Indicador 4 do Previne Brasil",

    description: "Percentual de mulheres de 25 a 64 anos com citopatológico",

    link: "https://lookerstudio.google.com/u/0/reporting/a115ad0b-3308-4c0e-b429-2a62781ec77c/page/p_kxgf0ijvyc",

  },

  {

    id: 3,

    category: "Previne Brasil",

    image: "img/ind5.jpg",

    title: "Indicador 5 do Previne Brasil",

    description: "Percentual de crianças com a 3ª dose das vacinas VIP e Penta",

    link: "https://lookerstudio.google.com/u/0/reporting/95989f85-db6e-4bb5-9dd1-b59a3226785f/page/p_8uyskbv6lc",

  },

  {

    id: 4,

    category: "Previne Brasil",

    image: "img/ind6.png",

    title: "Indicador 6 do Previne Brasil",

    description: "Percentual de hipertensos com consulta e aferição de PA10:03 08/05/2023",

    link: "https://lookerstudio.google.com/u/0/reporting/e607233f-a74a-4f8f-b98a-7c3df3e836e2/page/p_uwsu2vu6lc",

  },

  {

    id: 5,

    category: "Previne Brasil",

    image: "img/ind7.jpg",

    title: "Indicador 7 do Previne Brasil",

    description: "Percentual de diabéticos com consulta e HbA1c solicitada",

    link: "https://lookerstudio.google.com/u/0/reporting/0b6728c8-db99-4b19-a4e2-a39819895dd9/page/p_mddb21kuyc",

  },

  {

    id: 6,

    category: "Atenção Primária",

    image: "img/popativa.jpg",

    title: "População Ativa na APS",

    description: "Dados do IBGE, população cadastrada e população ativa na Atenção Primária à Saúde",

    link: "https://lookerstudio.google.com/u/0/reporting/2b3acb44-2ce4-4181-addf-2524006e0a6f/page/p_khcnk9b1oc",

  },

  {

    id: 7,

    category: "Especialidades",

    image: "img/espec.jpg",

    title: "Exames e Consultas Especializadas",

    description: "Solicitações, filas, tempo de espera e oferta de exames e consultas especializadas",

    link: "https://lookerstudio.google.com/u/1/reporting/27db21db-7546-427d-bf12-41bb793e27ba/page/p_sj997kqgoc",

  },





  {

    id: 8,

    category: "Especialidades",

    image: "img/reg2.png",

    title: "Devolvidos APS",

    description: "Encaminhamentos da APS devolvidos pela Regulação",

    link: "https://lookerstudio.google.com/u/1/reporting/a47cccdf-1d96-4a94-8b64-df530ca1f523/page/4Dc1B",

  },





  {

    id: 9,

    category: "Especialidades",

    image: "img/reg1.jpg",

    title: "Devolvidos Policlínicas",

    description: "Encaminhamentos das Policlínicas devolvidos pela Regulação",

    link: "https://lookerstudio.google.com/u/1/reporting/6e84d078-a4c0-4d6d-9e25-f98e54557c31/page/4Dc1B",

  },

  {

    id: 10,

    category: "Controle Social",

    image: "img/espec2.jpg",

    title: "Exames e Consultas Especializadas - Painel Aberto",

    description: "Informações sobre exames e consultas especializadas",

    link: "https://lookerstudio.google.com/u/0/reporting/20c8dc4f-4cfd-45af-87c3-be09a7e0dd23/page/p_sj997kqgoc",

  },



 {

    id: 11,

    category: ["Vacinação","Controle Social"],

    image: "img/vac1.jpg",

    title: "Vacinômetro - Painel Aberto",

    description: "Informações sobre exames e consultas especializadas",

    link: "https://lookerstudio.google.com/u/0/reporting/0cc4dda4-9bae-4452-9836-efd2ae73d6d3/page/p_py93q3uhsc",

  },



 {

    id: 12,

    category: "Vacinação",

    image: "img/vac.jpg",

    title: "Vacinômetro - Gestão e APS",

    description: "Informações sobre exames e consultas especializadas",

    link: "https://lookerstudio.google.com/u/1/reporting/a3365149-2fdd-443e-a6e6-2c9149d6cad1/page/p_t6pxrnqktc",

  },



 {

    id: 13,

    category: "Vacinação",

    image: "img/vac2.jpg",

    title: "Vacinômetro - GVE",

    description: "Informações sobre exames e consultas especializadas",

    link: "https://lookerstudio.google.com/u/1/reporting/12bdfd61-828f-435e-aa6b-e67dd17c17eb/page/gzzRC",

  },



 {

    id: 14,

    category: ["Controle Social","Instrumentos de Gestão"],

    image: "img/epidemio.jpg",

    title: "Demografia e morbimortalidade",

    description: "Informações sobre demografia e indicadores de morbimortalidade da população de Florianópolis",

    link: "https://saudefloripa.shinyapps.io/monitoramento_sus/",

  },



 {

    id: 15,

    category: ["Controle Social","Instrumentos de Gestão"],

    image: "img/atendimentos.jpg",

    title: "Atendimentos na Rede de Atenção à Saúde",

    description: "Informações sobre os atendimentos realizados na rede pública municipal de saúde",

    link: "https://lookerstudio.google.com/u/1/reporting/47480f0c-262b-40ca-98bd-612df6f09980/page/hkQPD",

  },



{

    id: 16,

    category: ["Qualidade de Dados","Atenção Primária"],

    image: "img/logradouros.jpg",

    title: "Logradouros e Centros de Saúde de referência",

    description: "Logradouros que compõem o território dos Centros de Saúde, conforme cadastrados no Sistema de Registo Eletrônico em Saúde",

    link: "https://lookerstudio.google.com/reporting/2cf13208-daa8-41e4-9ca9-e7c7e1e55a2f/page/7XQQD",

  },



{

    id: 17,

    category: ["Qualidade de Dados","Atenção Primária"],

    image: "img/cad.jpg",

    title: "Cadastros incompletos",

    description: "Listagem de cadastros que não possuem equipe ou CPF, para apoio às ações de atualização cadastral",

    link: "https://lookerstudio.google.com/u/0/reporting/cd3c0794-fcb5-490f-becb-6215c146c16f/page/wi6zC",

  },





{

    id: 18,

    category: "Contatos",

    image: "img/zap.jpg",

    title: "Contatos das Unidades de Saúde",

    description: "Telefones, números de Whatsapp e redes sociais das Unidades e Equipes",

    link: "https://sus.floripa.br/centrosdesaude",

  },







 // ... Adicione mais cards de exemplo aqui

];



const cardGallery = document.querySelector(".card-gallery");

const menuItems = document.querySelectorAll(".menu-item");



function createCard(card) {

  const cardElement = document.createElement("div");

  cardElement.className = "card";

  cardElement.innerHTML = `

    <img src="${card.image}" alt="${card.title}" />

    <h3 class="card-title">${card.title}</h3>

    <p class="card-description">${card.description}</p>

    <button class="card-button" data-link="${card.link}">Acessar</button>

  `;

  

  const cardButton = cardElement.querySelector(".card-button");

  cardButton.addEventListener("click", () => {

    window.open(card.link);

  });



  return cardElement;

}



function filterCards(category) {

  cardGallery.innerHTML = "";

  const filteredCards = cardData.filter((card) =>

    category === "Todos os painéis" || card.category.includes(category)

  );

  filteredCards.forEach((card) => {

    const cardElement = createCard(card);

    cardGallery.appendChild(cardElement);

  });

}



menuItems.forEach((menuItem) => {

  menuItem.addEventListener("click", (event) => {

    event.preventDefault();

    const category = menuItem.textContent;

    filterCards(category);

  });

});



// Carregue todos os cards na inicialização

filterCards("Todos os painéis");

