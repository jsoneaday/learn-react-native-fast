do $$
DECLARE
    row_count INTEGER;
    
begin
    create table profile (
        "id" bigserial primary key,
        "created_at" timestamptz(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
        "updated_at" timestamptz(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
        "user_name" varchar(50) NOT NULL,
        "full_name" varchar(100) NOT NULL,
        "description" varchar(250) NOT NULL,
        "region" varchar(50),
        "main_url" varchar(250),
        "avatar" bytea
    );

    select count(*) from profile into row_count;
    if row_count = 0 then
        insert into profile (user_name, full_name, description, region, main_url) values ('jon', 'Jon Davidson', 'I am a programmer', 'usa', 'http://test1.com');
        insert into profile (user_name, full_name, description, region, main_url) values ('lynn', 'Lynn Thomas', 'I am a singer', 'France', 'http://test2.com');
        insert into profile (user_name, full_name, description, region, main_url) values ('fran', 'Fran Arrington', 'I am a rocket scientist', 'usa', 'http://test3.com');
        insert into profile (user_name, full_name, description, region, main_url) values ('tim', 'Tim Wang', 'I am a chef', 'Italy', 'http://test4.com');
        insert into profile (user_name, full_name, description, region, main_url) values ('lisa', 'Lisa Wing', 'I am a teacher', 'usa', 'http://test5.com');
        insert into profile (user_name, full_name, description, region, main_url) values ('jimmy', 'James Dean', 'I am an actor', 'usa', 'http://test6.com');
    end if;

    create table follow (
        "id" bigserial primary key,
        "created_at" timestamptz(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
        "updated_at" timestamptz(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
        "follower_id" bigserial NOT NULL,
        "following_id" bigserial NOT NULL,

        constraint fk_profile_follower foreign key(follower_id) references profile(id),
        constraint fk_profile_following foreign key(following_id) references profile(id)
    );

    select count(*) from follow into row_count;
    if row_count = 0 then
        insert into follow (follower_id, following_id) values (1, 2);
        insert into follow (follower_id, following_id) values (3, 2);
        insert into follow (follower_id, following_id) values (4, 2);
        insert into follow (follower_id, following_id) values (5, 2);
        insert into follow (follower_id, following_id) values (1, 3);
        insert into follow (follower_id, following_id) values (1, 4);
        insert into follow (follower_id, following_id) values (1, 5);
        insert into follow (follower_id, following_id) values (1, 6);
    end if;

    create table message (
        "id" bigserial primary key,
        "created_at" timestamptz(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
        "updated_at" timestamptz(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
        "user_id" bigserial NOT NULL,
        "body"  varchar(140),
        "likes" int NOT NULL DEFAULT 0,
        "image" bytea,
        "msg_group_type" int NOT NULL,

        constraint fk_profile foreign key(user_id) references profile(id)
    );

    select count(*) from message into row_count;
    if row_count = 0 then
        insert into message (user_id, body, likes, msg_group_type, image) 
            values (
                1, 
                'Matt told her to reach for the stars, but Veronica thought it was the most ridiculous advice she''d ever received.', 
                231, 
                1,
                decode('89504e470d0a1a0a0000000d4948445200000040000000400806000000aa' ||
                    '6971de0000000473424954080808087c0864880000000970485973000001' ||
                    '6200000162015f27d0530000001974455874536f66747761726500777777' ||
                    '2e696e6b73636170652e6f72679bee3c1a000011af49444154789cb59b7b' ||
                    '9c54d591c7bfe7beba67bae73d3d6f18077086a718c1a888a292acd12888' ||
                    'c9222e1076b32686108d261fd78f4936c67c367e9235598daea2319a8002' ||
                    '42d4444dd49095a0a22204e5fd52811ee6c1bca7a7bba7bb6ff7bd67ffe8' ||
                    '79f4cc74cf4c0fc3efafee7babea56d53da74e9d3a7585949273014f7979' ||
                    '0d52b9d2edd22a2655382fb2a45a1532f532d3d2b3344d5098a35833a638' ||
                    '943b97179b134b8c3a100d201b8006a46c4015277046b6e1d91238270af6' ||
                    '408ca70384109aa7b4628d6e886f47a3b21a405155f20b3c180e47521e29' ||
                    '6de64e5578f2fef3d05531f87604d88614afa289d7a858573f6ecaf6ea3c' ||
                    '5e0e987349cd15a160f40fad1dd1e2de6b9aae53505884aa6923f2bb9d16' ||
                    '6faeadc29da9a62291c01e603346e613943ed53d1e7a2b672f62a9ba79ed' ||
                    '171ee8688f6c4f345e51140a8b4a46653c4020ac72dbfda7862311c05ce0' ||
                    '21ccee4ff0aebc0d96a6f4d66871760ea85d7143fd2e0e3ff0f8c91f07ba' ||
                    'ad01b232dd6e14253df147bd820ff6fa47435a063c8dd7b19fda1537a4f5' ||
                    '9041189b034e2eafc4bb723b52bcf6ebe7bcd5ad1de680db42085ceeecf4' ||
                    'e50ac196ad1de9704c478ad7f0aedccec9e595e93f702c0ea85d351f45d9' ||
                    '0d2cf03684d8f06ae3101255d350d5e4a3d3b66d22e110c1801fbfaf137f' ||
                    '978f60c04f3814c2b62c0e7f16495b2560018ab29bda55f3d3654ccf01de' ||
                    '155f47da6f011e8097b636138d0d0da2d2b607fc8f8443f83adb6939d348' ||
                    '53431d5dbe4ecc48042925b66d619a1102fe2e9a1aeb99e089a66b432f3c' ||
                    '48fb2dbc2bbe9e0ed3e822144b55bc8e8740dc9d78f5bd3d9d49a96ddb46' ||
                    '4a49a83b48c0df05125455452882ac9c5c5c2e3722497c9052e26d8175af' ||
                    'f9b8745606d5950662c8ca382c0c10cfe05d3993cac83db0c51a896114cb' ||
                    'e052955ae325a4589c78d58cda4cfee20e22a69d944b51555455c3b62c2c' ||
                    '2b861082fcc2221c4ee7a8ada928d6b87b453e0b3fef1a354f1f847c8589' ||
                    'e6574672c2c853c0eb7868b0f1009fd586521aaf693aaaaa12352363361e' ||
                    'a0ae29c6f77fd5cc377edac8f15a7364864448b1383e6a87c7f00e88cfa7' ||
                    'bb93ddeaf40f9dab42080c8783582c4ad4ec5738afa0306de313b1fb5098' ||
                    '65f7d6f3e0336d44a269256e778f1413523ba076d57c106b53ddf6f96303' ||
                    'fe0b21d0341d3332308aeb868133237354da0e07db862d5bbbb8e3e74d84' ||
                    '22e93841ac1d6e7548ee8093cb2b91f6cb80918ab12b30d0019aae138d0e' ||
                    '1da6eeac31e403c360d7c110773dd4441a19bc81b45f4e9527247780a2ac' ||
                    'a367a94b85d68efe2960381c03867c2f54551d97b73f181f1e08f1c25fbb' ||
                    'd261f1f4d83404431d104f2d178c24b1be293ed415454d6a3c8033231331' ||
                    '681d13022a3dd95c5455cc35332bb9626a05e5f9ee112d188c4737b6d3d1' ||
                    '35e22a978805c9d2e64179c05215e9f8c568a4d53585e302746dc8bcef85' ||
                    '92900d5615e5b06cde34e655975398953180ee957f7ccacf5fd9399ac7f6' ||
                    '211491bcbe23c8f2ebd3986252fc0296be91b8340e1c015ec7bf01d34792' ||
                    '13316d76edf701f1a42715545525c3d0f8ceb517f1dc9a1b583467ca10e3' ||
                    '01546568b693eb7230a1306b583dfef26edab592e93d36f6a1df018db767' ||
                    '020f8c46cae637ced0d6198f01b1582c25dd9cc9656cfeee2296cf9f9ed4' ||
                    'c85ed494e60fb9d6198c30bdbc90cb6bca53f21df79ad8e997331ee8b115' ||
                    '487480d9fd6de2dbcc6171e8d3000f3e751288bfe154e17852a987dfae5e' ||
                    '84277be420787e691eb32b8b865cffebbe93dc70d1646e993735295fcc92' ||
                    'b476a4150700ca7a6c05064e815b060befec59eb43618b86e6088f6f38cd' ||
                    '92357b69ef79fbc9f27980fc6c377fbaf716d22907fce4ab97539e373418' ||
                    'fee2d55dacba7226d75d3829295f9b2f6d074082adf12058b7aa1c989348' ||
                    'a1a982b73e68e3be5f7dd2e788c148b68fc8743ad8b2e646dc9943e7fa70' ||
                    '28c975b1f6b67f62fd3b87f8ebfe93f84326aa22983ba9984038cabd8b2e' ||
                    'e1d3a60e3e691c582f701ae9ed967a3087ba55e554acab8f6f864e7ded5b' ||
                    '089934eb6bed30f9afb527d9f497c621a35d55552c6be01b78e2ebd7b1a0' ||
                    'ba0c575151ca1132126c298959368a10686abf8cd36d7e6e7df455ac8489' ||
                    'bf75ed448af2c75019936235e7ad7f323e02845c948aae30cfe0911fd4b0' ||
                    '6a4919bffd431d3bf7f938dd185f02ed4111a8baa28805d565084541280a' ||
                    '3b3f69607f6d0bde161f1505d9cc9c50c8fc9a8a945b5c29e1fde3f51c3c' ||
                    'dd426d6b17130bb39939c1c3bcea7284800905595c3bbb8ad73f3ed1c7e3' ||
                    'ca18d308e8b5f949219bffd94db7a315485eb74e82c696083bf7f9385917' ||
                    'e2e7bf89074421042f7e7709534bf2680f457978c767ec3c5e87aaaa1417' ||
                    '17d1dcdc4c2c66f1b9aa627eb8e4b221f3bda123c0cf5ed9c5479f35f4f1' ||
                    '343535635916732797f0a32597519ce3a2b6b58b5b1f7d0d5b4a84808f36' ||
                    '55a55b33e84584cc48a190b52b1661f3ca9844001557edc03463ccae2a63' ||
                    'e3edd711b3256b5eda439d2fc4a265cbb9ecea85e8ba4eb1dbc9915d1ff0' ||
                    'd0c3bf262f43e3b935d7e3d4e3033012b558f1c41bb405232c5efe353e3f' ||
                    'ff4a345da7c465b0f7bd7779f8b1c729cd71f2fbd5d7a3ab0a3fdcfc2edb' ||
                    '0e7a29f568bcf1bf13c6aa3a282cd6b0e4a4b1ba10a0d49389b7be8b6ea9' ||
                    'f1e2de5aba22514e3477f2ef777d9fd9175fd247d7140873c5350b292d29' ||
                    'e15b77dec56fdedac79d5f8ac7dd67b71fa0becdc79afb7e44f58c597d3c' ||
                    '6782265fb8ee7a4a4b8ab9e3fbffc1d36fedc3edd4d977aa09801993463d' ||
                    '6893c3929334841871ed4fca1bccc30e143073e2191a5b424c28cce5a9f7' ||
                    '8e63682a936ba60e30fee8817dbcbfedff98bfe02a6efbca8dcc9f7719db' ||
                    '0f1fe873c0f6a30d4cbff07354cf98c5de5d3bf9e883f7b87ce117a99979' ||
                    '01759d01aeb87c1e975c3c874def7f4cccb29939c183cba133bdb0826853' ||
                    '058abb0dd5955635390e21ca144691fc0c46b4a50ab37e3a315f31f72dbe' ||
                    '8aab6754f1d8572fe6919be712b36c26d54ceba38d45a3ac7bfc515c0a14' ||
                    '39357c3e1f17cc9c4163879fc5bf7c999b7ef9476a9bdb396fcaf904037e' ||
                    '9e7be231f2320c0a448c58344ab719cf3966cd98896d4b9eb9fd4b3cfdcd' ||
                    '6bb979ee14ae9b5643cc578c593f9d684b55fa0e803205d21b0176772eb1' ||
                    '8e7e9662b783ffb9e50a00a695e4a0692a6624dc775fd534323233f960d7' ||
                    '6e9e7a761d4ea79370388c1082191585cca828405114cc88896138301c4e' ||
                    'ded9f13e1bfef012aaa6a1f44ccf70248caea94c2d2b00e0e63993483c45' ||
                    '8b75946177e7a669bf28d340a6e5002bd09fb777b7b46027e4018a104c29' ||
                    'cce2d8c1fdd8b68da2280821f8ce0f7eccde0f77326fde651886c187bbff' ||
                    '41a5278707975d09c0aa27dfe4f8a103dcb0741977ddff530e7dfc11175e' ||
                    '72294208dc4e03dbb6d9b57b0fe797e6a1f4ec29ec6894687737b150884c' ||
                    '8fa74f37253379a53a3964fa53405af1c82d6d3be94ef0cbd34b39535fcf' ||
                    'df5efd63dfb5fc420fd77cf946e6cd9ac6e6175fe6e0e123dc34674adffd' ||
                    '45174dc2fbd9a7bcbbf54d8acbcab9e6cb37925fe841009579593cb7f105' ||
                    '8e7ffa298b1378ec9e4d986ddb7de710bdbaa58132f527775d701f69e400' ||
                    'd232b08379082150751d69dbc8845130b9308b136d01de7a6f172d4d67c8' ||
                    'cac9c570383102ed6cdab091a77fb78ecbabcbf9f615d5c4422162e130d5' ||
                    '9e2c3e6bebe6cd6defd0d1d68a3b2b1b87c389d6d5c6badfff8ef51b5f60' ||
                    '5e7539777ce9a2bee7987e3faaaee3ccce46d17500b4dc2614675a5b6453' ||
                    'c8532b8e0235a366910a61ef8548339eebc74221c23edf0092982dd9b4e7' ||
                    '141bf79c2466f58f1245086ebd7c1adfbc7a167630d0b7971042a0b8dc3c' ||
                    'f3f6419edf7164c0c85215856573abb8fdfa4bd07bd2626959045b5a70e6' ||
                    'e4a065c4f510460867e55e10a9eb1349704cc8532bb781bc3a1d2e69e944' ||
                    '9b276105f2b12231a2e14e146737667b7fe95b280afe98e4588b9f7abfc9' ||
                    '84c26ca69517242d8824a23d10e6487d1bde161f6559063545d9147bf251' ||
                    '128ed96ddb8f1908a13b73511d1aaabb1dbde804424df7584dfc5dc8532b' ||
                    '9e0796a7c9198714484b476826b1a041c79e815999ee72e1c81abeaa93f6' ||
                    '23a58da3f2635467181933e2468b3137796cd08086316b2324428b174435' ||
                    '9789b3d84fb8a9dfe06830889e9131e0ed998100762c866a18a846bcea6e' ||
                    '99269669a2681a867bf802a9709e4175c697d9de679f051a34a46c389b54' ||
                    '3811aef3da313b32b1cdfe053ad2d545467effd2a9ea3a762c861908f445' ||
                    '6fa1287187f404b354b06d13d7c453e3a22b00523668a8e20469c58dd450' ||
                    '1c31b2a79fc1b7bf0c69c79d6a9926d15008bd2758a90e076a4fc354ef52' ||
                    'a68ca68d464af4a2136733dc87421527149c916dc4bbb1c6057a7698aca9' ||
                    '4d08a55fd188cf87190c0ea155346d54c64bdb42f31cc5c86f1b2f350122' ||
                    '3823db949e3ebc6de329d9511824e7820614bd3f3f30fdfef8729966579a' ||
                    '6d477054ee45cf6f1f4f1501b6e1d912e85958c5abe32d5dcf0e93fbb93a' ||
                    '1c9efec424160a116a6f1f90380d07491799e77f8c9a111e99385df4d81c' ||
                    'af09d6ad2ac7b24f136f451b77c4fc0eba4fe761b667f6c506cde140733a' ||
                    '519dce01c767b61545383a308a1ad1dce7ac4954a22a13a858571f1f01f1' ||
                    '0ecc3de7ea695a5604b53a93ee2917f45d8b4522847d3e82cdcd843b3b31' ||
                    '0301ba5b5b69cbaf404eb4cea5f1007b7abb4e1323d066e28d88e38a0e53' ||
                    'e7987f09798e0a345a1992074a492c1c1fe28aae63d919d4856fe24ca889' ||
                    '59395bc837c6dc34351c36f7fee8af391b994f703649d1207cd892c737de' ||
                    '9f4df5cbd7501b8cefe16dbddf7cd5e1c0c8cac2919343465e1eaea22232' ||
                    '0b0ab01cf144aacd2ae3c20fee63eebbdfe2cf0d636a014c85861e5b8144' ||
                    '07c47b6fef3f5be9515b70cf3fa6f385ad97f2c2c932c296c2c18e1000b6' ||
                    'c3856df438414a0c970b3d2303d5e140280a514b6219f1a3b423dd1a0895' ||
                    '6659caea4f56b164e7224c7b1c3a7be1fec43ee381122b23bf030e8f55f2' ||
                    '9990836bff76294f1e1bf8c60e75f6a7acc109b381fef4b717524afcee92' ||
                    'beffc782fdd9a4102a7bcc39cc7ae73b1ce82a18ab7a00877b6cecc32097' ||
                    '6eb110f2deb1488ed80acbde9ec3eed6a165a913b2ffe0339a538c7fca65' ||
                    '580e37a1f676cc40809865d39c7b3e81bcf3fae88e04879ef6849402bef2' ||
                    'd14a42f6187ba485bc7770db5cf23e41efcaed8ca24b2411777c3893df7f' ||
                    '3ab4466fb83cb8f227f3a7d97e5c6a426d4051703b75b06d02a635a00610' ||
                    'b4146eda977a173953dbc7ebf35e4e473d80b7a97ceeaac117934f2adb5e' ||
                    '05b48c56f2dfcf1424355e510d3273e3d3e16877ff5b73b9dc141597e0ce' ||
                    'f3e02e28a6a8b80497ab7f1798489b0c07a2b3d8583b65589a4168e9b169' ||
                    'a88e49c9ab367811cacdc0a8f69b4f1c3d2fe9f58cdc4a84125f69f7fb55' ||
                    '428a93a2e21272727307b4d22b8a424e6e2e45c525841427fbfdc33b4008' ||
                    '859f9dba7e34aa019808e566aa367893dd4c1d5627aedb0172f548d24f06' ||
                    '32d9da90bca14c77e6f4fdded2e4e0ce231998a436ce44e5ce23196c691a' ||
                    'b944e9279f235d3923d2815c1db72539865f572a9f7f16787838926d8d85' ||
                    'd8726806ad68cebeb70f1093702a68b3f4dd6e8e750ddd7f1feb8adf3b15' ||
                    'b449d2809e04822da7cf1f89e8e11e1b5262e4bd6865e41e6a8d49c9fa85' ||
                    '01bc81e4353ecd48dee07c326073f3db41aab3152e2d8c3f7e676b8ce349' ||
                    '9c32120e054b53df8c374bdf33928c5164165bac78d775f291e00d267780' ||
                    '6a0c5fda3ade65b3fe84c9fa13e6988c07f04652f6723e3c9a4e7118f5f7' ||
                    '025b2c2af91ede15077bfa87fb5a685bc2c9e7abaa9de5c9ed28d0650d71' ||
                    'b20972f548c33e11e9e59695cf3f8b501692b044a6ae6f9c939df570cf68' ||
                    '41280bd3311ec6f2cdd0c4753bb0ed8b81b7d3e63d77781bdbbe78b8689f' ||
                    '0a691fa601f4aca95751bbe206099b80f49b7dc7059685903731f1f93f8f' ||
                    '55c2d96daf263eff67e908972c9f5cbfbe3a2b90ba65749ca1595db2463d' ||
                    'b4232f565b7436c6c3787e3bdc787be6637b8b1ef94b7dc9d2f79bf3725c' ||
                    '8535e81979e3239bf88950ae3c632ecc3dfcfa239fdfb37cbc3e9d1dd78f' ||
                    'a77bf1cd4d0f2df8283cebc9564aab6dcdad9c4d401456b79d2fce9c986c' ||
                    'd47defc55bfff5b57154332eff5c7d3edf8bebd6afbf003deb3f9ba27973' ||
                    '4ce9c833a523238aa1db8aa148d1dba6184391a6ad4b336a88482883605b' ||
                    'a1e1db133123ffbd6dd5bf9cb35a25c0ff038e25e3b4d6210ac200000000' ||
                    '49454e44ae426082', 'hex'
                    )
            );
        insert into message (user_id, body, likes, msg_group_type) values (2, 'They decided to find the end of the rainbow. While they hoped they would find a pot of gold.', 2, 1);
        insert into message (user_id, body, likes, msg_group_type) values (1, 'Of course he was getting them, but if he wasn''t getting them, how would he ever be able to answer?', 56, 1);
        insert into message (user_id, body, likes, msg_group_type) values (3, 'Zeke read the sign as an invitation to explore an area that would be adventurous and exciting.', 897, 1);
        insert into message (user_id, body, likes, msg_group_type) values (3, 'Just came back from visiting Italy and it was wonderful.', 12, 1);
        insert into message (user_id, body, likes, msg_group_type) values (4, 'She sat deep in thought. The next word that came out o her mouth would likely be the most important word of her life.', 234, 1);
        insert into message (user_id, body, likes, msg_group_type) values (4, 'The rain was coming. Everyone thought this would be a good thing. It hadn''t rained in months and the earth was dry as a bone.', 23, 1);
        insert into message (user_id, body, likes, msg_group_type) values (5, 'Luckily dogs don''t discriminate. Just watch at a dog park. Big black and white dogs wag their tails and play with tiny tan dogs.', 4, 1);
        insert into message (user_id, body, likes, msg_group_type) values (6, 'He looked at the sand. Picking up a handful, he wondered how many grains were in his hand. Hundreds of thousands? "Not enough,"', 14, 1);
        insert into message (user_id, body, likes, msg_group_type) values (6, 'Gone with the Wind is the greatest movie of all time.', 40, 1);
        insert into message (user_id, body, likes, msg_group_type) values (5, 'The bowl was filled with fruit. It seemed to be an overabundance of strawberries, but it also included grapes and banana slices', 7, 1);
        insert into message (user_id, body, likes, msg_group_type) values (2, 'The only one who had disagreed with this sentiment was her brother.', 21, 1);
        insert into message (user_id, body, likes, msg_group_type) values (2, 'Patrick didn''t want to go. The fact that she was insisting they must go made him want to go even less.', 23, 1);
        insert into message (user_id, body, likes, msg_group_type) values (3, 'He couldn''t move. His head throbbed and spun. He couldn''t decide if it was the flu or the drinking last night.', 65, 1);
        insert into message (user_id, body, likes, msg_group_type) values (3, 'He slowly poured the drink over a large chunk of ice he has especially chiseled off a larger block.', 87, 1);
        insert into message (user_id, body, likes, msg_group_type) values (5, 'She wished that she could simply accept the gesture and be content knowing someone had given it to her.', 09, 1);
        insert into message (user_id, body, likes, msg_group_type) values (5, 'She sat deep in thought. The next word that came out o her mouth would likely be the most important word of her life.', 4, 1);
        insert into message (user_id, body, likes, msg_group_type, image) 
            values (
                1, 
                'They would have never believed they would actually find the end of a rainbow, and when they did, what they actually found there.', 
                435, 
                1,
                decode('89504e470d0a1a0a0000000d4948445200000040000000400806000000aa' ||
                    '6971de0000000473424954080808087c0864880000000970485973000001' ||
                    '6200000162015f27d0530000001974455874536f66747761726500777777' ||
                    '2e696e6b73636170652e6f72679bee3c1a000011af49444154789cb59b7b' ||
                    '9c54d591c7bfe7beba67bae73d3d6f18077086a718c1a888a292acd12888' ||
                    'c9222e1076b32686108d261fd78f4936c67c367e9235598daea2319a8002' ||
                    '42d4444dd49095a0a22204e5fd52811ee6c1bca7a7bba7bb6ff7bd67ffe8' ||
                    '79f4cc74cf4c0fc3efafee7babea56d53da74e9d3a7585949273014f7979' ||
                    '0d52b9d2edd22a2655382fb2a45a1532f532d3d2b3344d5098a35833a638' ||
                    '943b97179b134b8c3a100d201b8006a46c4015277046b6e1d91238270af6' ||
                    '408ca70384109aa7b4628d6e886f47a3b21a405155f20b3c180e47521e29' ||
                    '6de64e5578f2fef3d05531f87604d88614afa289d7a858573f6ecaf6ea3c' ||
                    '5e0e987349cd15a160f40fad1dd1e2de6b9aae53505884aa6923f2bb9d16' ||
                    '6faeadc29da9a62291c01e603346e613943ed53d1e7a2b672f62a9ba79ed' ||
                    '171ee8688f6c4f345e51140a8b4a46653c4020ac72dbfda7862311c05ce0' ||
                    '21ccee4ff0aebc0d96a6f4d66871760ea85d7143fd2e0e3ff0f8c91f07ba' ||
                    'ad01b232dd6e14253df147bd820ff6fa47435a063c8dd7b19fda1537a4f5' ||
                    '9041189b034e2eafc4bb723b52bcf6ebe7bcd5ad1de680db42085ceeecf4' ||
                    'e50ac196ad1de9704c478ad7f0aedccec9e595e93f702c0ea85d351f45d9' ||
                    '0d2cf03684d8f06ae3101255d350d5e4a3d3b66d22e110c1801fbfaf137f' ||
                    '978f60c04f3814c2b62c0e7f16495b2560018ab29bda55f3d3654ccf01de' ||
                    '155f47da6f011e8097b636138d0d0da2d2b607fc8f8443f83adb6939d348' ||
                    '53431d5dbe4ecc48042925b66d619a1102fe2e9a1aeb99e089a66b432f3c' ||
                    '48fb2dbc2bbe9e0ed3e822144b55bc8e8740dc9d78f5bd3d9d49a96ddb46' ||
                    '4a49a83b48c0df05125455452882ac9c5c5c2e3722497c9052e26d8175af' ||
                    'f9b8745606d5950662c8ca382c0c10cfe05d3993cac83db0c51a896114cb' ||
                    'e052955ae325a4589c78d58cda4cfee20e22a69d944b51555455c3b62c2c' ||
                    '2b861082fcc2221c4ee7a8ada928d6b87b453e0b3fef1a354f1f847c8589' ||
                    'e6574672c2c853c0eb7868b0f1009fd586521aaf693aaaaa12352363361e' ||
                    'a0ae29c6f77fd5cc377edac8f15a7364864448b1383e6a87c7f00e88cfa7' ||
                    'bb93ddeaf40f9dab42080c8783582c4ad4ec5738afa0306de313b1fb5098' ||
                    '65f7d6f3e0336d44a269256e778f1413523ba076d57c106b53ddf6f96303' ||
                    'fe0b21d0341d3332308aeb868133237354da0e07db862d5bbbb8e3e74d84' ||
                    '22e93841ac1d6e7548ee8093cb2b91f6cb80918ab12b30d0019aae138d0e' ||
                    '1da6eeac31e403c360d7c110773dd4441a19bc81b45f4e9527247780a2ac' ||
                    'a367a94b85d68efe2960381c03867c2f54551d97b73f181f1e08f1c25fbb' ||
                    'd261f1f4d83404431d104f2d178c24b1be293ed415454d6a3c8033231331' ||
                    '681d13022a3dd95c5455cc35332bb9626a05e5f9ee112d188c4737b6d3d1' ||
                    '35e22a978805c9d2e64179c05215e9f8c568a4d53585e302746dc8bcef85' ||
                    '92900d5615e5b06cde34e655975398953180ee957f7ccacf5fd9399ac7f6' ||
                    '211491bcbe23c8f2ebd3986252fc0296be91b8340e1c015ec7bf01d34792' ||
                    '13316d76edf701f1a42715545525c3d0f8ceb517f1dc9a1b583467ca10e3' ||
                    '01546568b693eb7230a1306b583dfef26edab592e93d36f6a1df018db767' ||
                    '020f8c46cae637ced0d6198f01b1582c25dd9cc9656cfeee2296cf9f9ed4' ||
                    'c85ed494e60fb9d6198c30bdbc90cb6bca53f21df79ad8e997331ee8b115' ||
                    '487480d9fd6de2dbcc6171e8d3000f3e751288bfe154e17852a987dfae5e' ||
                    '84277be420787e691eb32b8b865cffebbe93dc70d1646e993735295fcc92' ||
                    'b476a4150700ca7a6c05064e815b060befec59eb43618b86e6088f6f38cd' ||
                    '92357b69ef79fbc9f27980fc6c377fbaf716d22907fce4ab97539e373418' ||
                    'fee2d55dacba7226d75d3829295f9b2f6d074082adf12058b7aa1c989348' ||
                    'a1a982b73e68e3be5f7dd2e788c148b68fc8743ad8b2e646dc9943e7fa70' ||
                    '28c975b1f6b67f62fd3b87f8ebfe93f84326aa22983ba9984038cabd8b2e' ||
                    'e1d3a60e3e691c582f701ae9ed967a3087ba55e554acab8f6f864e7ded5b' ||
                    '089934eb6bed30f9afb527d9f497c621a35d55552c6be01b78e2ebd7b1a0' ||
                    'ba0c575151ca1132126c298959368a10686abf8cd36d7e6e7df455ac8489' ||
                    'bf75ed448af2c75019936235e7ad7f323e02845c948aae30cfe0911fd4b0' ||
                    '6a4919bffd431d3bf7f938dd185f02ed4111a8baa28805d565084541280a' ||
                    '3b3f69607f6d0bde161f1505d9cc9c50c8fc9a8a945b5c29e1fde3f51c3c' ||
                    'dd426d6b17130bb39939c1c3bcea7284800905595c3bbb8ad73f3ed1c7e3' ||
                    'ca18d308e8b5f949219bffd94db7a315485eb74e82c696083bf7f9385917' ||
                    'e2e7bf89074421042f7e7709534bf2680f457978c767ec3c5e87aaaa1417' ||
                    '17d1dcdc4c2c66f1b9aa627eb8e4b221f3bda123c0cf5ed9c5479f35f4f1' ||
                    '343535635916732797f0a32597519ce3a2b6b58b5b1f7d0d5b4a84808f36' ||
                    '55a55b33e84584cc48a190b52b1661f3ca9844001557edc03463ccae2a63' ||
                    'e3edd711b3256b5eda439d2fc4a265cbb9ecea85e8ba4eb1dbc9915d1ff0' ||
                    'd0c3bf262f43e3b935d7e3d4e3033012b558f1c41bb405232c5efe353e3f' ||
                    'ff4a345da7c465b0f7bd7779f8b1c729cd71f2fbd5d7a3ab0a3fdcfc2edb' ||
                    '0e7a29f568bcf1bf13c6aa3a282cd6b0e4a4b1ba10a0d49389b7be8b6ea9' ||
                    'f1e2de5aba22514e3477f2ef777d9fd9175fd247d7140873c5350b292d29' ||
                    'e15b77dec56fdedac79d5f8ac7dd67b71fa0becdc79afb7e44f58c597d3c' ||
                    '6782265fb8ee7a4a4b8ab9e3fbffc1d36fedc3edd4d977aa09801993463d' ||
                    '6893c3929334841871ed4fca1bccc30e143073e2191a5b424c28cce5a9f7' ||
                    '8e63682a936ba60e30fee8817dbcbfedff98bfe02a6efbca8dcc9f7719db' ||
                    '0f1fe873c0f6a30d4cbff07354cf98c5de5d3bf9e883f7b87ce117a99979' ||
                    '01759d01aeb87c1e975c3c874def7f4cccb29939c183cba133bdb0826853' ||
                    '058abb0dd5955635390e21ca144691fc0c46b4a50ab37e3a315f31f72dbe' ||
                    '8aab6754f1d8572fe6919be712b36c26d54ceba38d45a3ac7bfc515c0a14' ||
                    '39357c3e1f17cc9c4163879fc5bf7c999b7ef9476a9bdb396fcaf904037e' ||
                    '9e7be231f2320c0a448c58344ab719cf3966cd98896d4b9eb9fd4b3cfdcd' ||
                    '6bb979ee14ae9b5643cc578c593f9d684b55fa0e803205d21b0176772eb1' ||
                    '8e7e9662b783ffb9e50a00a695e4a0692a6624dc775fd534323233f960d7' ||
                    '6e9e7a761d4ea79370388c1082191585cca828405114cc88896138301c4e' ||
                    'ded9f13e1bfef012aaa6a1f44ccf70248caea94c2d2b00e0e63993483c45' ||
                    '8b75946177e7a669bf28d340a6e5002bd09fb777b7b46027e4018a104c29' ||
                    'cce2d8c1fdd8b68da2280821f8ce0f7eccde0f77326fde651886c187bbff' ||
                    '41a5278707975d09c0aa27dfe4f8a103dcb0741977ddff530e7dfc11175e' ||
                    '72294208dc4e03dbb6d9b57b0fe797e6a1f4ec29ec6894687737b150884c' ||
                    '8fa74f37253379a53a3964fa53405af1c82d6d3be94ef0cbd34b39535fcf' ||
                    'df5efd63dfb5fc420fd77cf946e6cd9ac6e6175fe6e0e123dc34674adffd' ||
                    '45174dc2fbd9a7bcbbf54d8acbcab9e6cb37925fe841009579593cb7f105' ||
                    '8e7ffa298b1378ec9e4d986ddb7de710bdbaa58132f527775d701f69e400' ||
                    'd232b08379082150751d69dbc8845130b9308b136d01de7a6f172d4d67c8' ||
                    'cac9c570383102ed6cdab091a77fb78ecbabcbf9f615d5c4422162e130d5' ||
                    '9e2c3e6bebe6cd6defd0d1d68a3b2b1b87c389d6d5c6badfff8ef51b5f60' ||
                    '5e7539777ce9a2bee7987e3faaaee3ccce46d17500b4dc2614675a5b6453' ||
                    'c8532b8e0235a366910a61ef8548339eebc74221c23edf0092982dd9b4e7' ||
                    '141bf79c2466f58f1245086ebd7c1adfbc7a167630d0b7971042a0b8dc3c' ||
                    'f3f6419edf7164c0c85215856573abb8fdfa4bd07bd2626959045b5a70e6' ||
                    'e4a065c4f510460867e55e10a9eb1349704cc8532bb781bc3a1d2e69e944' ||
                    '9b276105f2b12231a2e14e146737667b7fe95b280afe98e4588b9f7abfc9' ||
                    '84c26ca69517242d8824a23d10e6487d1bde161f6559063545d9147bf251' ||
                    '128ed96ddb8f1908a13b73511d1aaabb1dbde804424df7584dfc5dc8532b' ||
                    '9e0796a7c9198714484b476826b1a041c79e815999ee72e1c81abeaa93f6' ||
                    '23a58da3f2635467181933e2468b3137796cd08086316b2324428b174435' ||
                    '9789b3d84fb8a9dfe06830889e9131e0ed998100762c866a18a846bcea6e' ||
                    '99269669a2681a867bf802a9709e4175c697d9de679f051a34a46c389b54' ||
                    '3811aef3da313b32b1cdfe053ad2d545467effd2a9ea3a762c861908f445' ||
                    '6fa1287187f404b354b06d13d7c453e3a22b00523668a8e20469c58dd450' ||
                    '1c31b2a79fc1b7bf0c69c79d6a9926d15008bd2758a90e076a4fc354ef52' ||
                    'a68ca68d464af4a2136733dc87421527149c916dc4bbb1c6057a7698aca9' ||
                    '4d08a55fd188cf87190c0ea155346d54c64bdb42f31cc5c86f1b2f350122' ||
                    '3823db949e3ebc6de329d9511824e7820614bd3f3f30fdfef8729966579a' ||
                    '6d477054ee45cf6f1f4f1501b6e1d912e85958c5abe32d5dcf0e93fbb93a' ||
                    '1c9efec424160a116a6f1f90380d07491799e77f8c9a111e99385df4d81c' ||
                    'af09d6ad2ac7b24f136f451b77c4fc0eba4fe761b667f6c506cde140733a' ||
                    '519dce01c767b61545383a308a1ad1dce7ac4954a22a13a858571f1f01f1' ||
                    '0ecc3de7ea695a5604b53a93ee2917f45d8b4522847d3e82cdcd843b3b31' ||
                    '0301ba5b5b69cbaf404eb4cea5f1007b7abb4e1323d066e28d88e38a0e53' ||
                    'e7987f09798e0a345a1992074a492c1c1fe28aae63d919d4856fe24ca889' ||
                    '59395bc837c6dc34351c36f7fee8af391b994f703649d1207cd892c737de' ||
                    '9f4df5cbd7501b8cefe16dbddf7cd5e1c0c8cac2919343465e1eaea22232' ||
                    '0b0ab01cf144aacd2ae3c20fee63eebbdfe2cf0d636a014c85861e5b8144' ||
                    '07c47b6fef3f5be9515b70cf3fa6f385ad97f2c2c932c296c2c18e1000b6' ||
                    'c3856df438414a0c970b3d2303d5e140280a514b6219f1a3b423dd1a0895' ||
                    '6659caea4f56b164e7224c7b1c3a7be1fec43ee381122b23bf030e8f55f2' ||
                    '9990836bff76294f1e1bf8c60e75f6a7acc109b381fef4b717524afcee92' ||
                    'beffc782fdd9a4102a7bcc39cc7ae73b1ce82a18ab7a00877b6cecc32097' ||
                    '6eb110f2deb1488ed80acbde9ec3eed6a165a913b2ffe0339a538c7fca65' ||
                    '580e37a1f676cc40809865d39c7b3e81bcf3fae88e04879ef6849402bef2' ||
                    'd14a42f6187ba485bc7770db5cf23e41efcaed8ca24b2411777c3893df7f' ||
                    '3ab4466fb83cb8f227f3a7d97e5c6a426d4051703b75b06d02a635a00610' ||
                    'b4146eda977a173953dbc7ebf35e4e473d80b7a97ceeaac117934f2adb5e' ||
                    '05b48c56f2dfcf1424355e510d3273e3d3e16877ff5b73b9dc141597e0ce' ||
                    'f3e02e28a6a8b80497ab7f1798489b0c07a2b3d8583b65589a4168e9b169' ||
                    'a88e49c9ab367811cacdc0a8f69b4f1c3d2fe9f58cdc4a84125f69f7fb55' ||
                    '428a93a2e21272727307b4d22b8a424e6e2e45c525841427fbfdc33b4008' ||
                    '859f9dba7e34aa019808e566aa367893dd4c1d5627aedb0172f548d24f06' ||
                    '32d9da90bca14c77e6f4fdded2e4e0ce231998a436ce44e5ce23196c691a' ||
                    'b944e9279f235d3923d2815c1db72539865f572a9f7f16787838926d8d85' ||
                    'd8726806ad68cebeb70f1093702a68b3f4dd6e8e750ddd7f1feb8adf3b15' ||
                    'b449d2809e04822da7cf1f89e8e11e1b5262e4bd6865e41e6a8d49c9fa85' ||
                    '01bc81e4353ecd48dee07c326073f3db41aab3152e2d8c3f7e676b8ce349' ||
                    '9c32120e054b53df8c374bdf33928c5164165bac78d775f291e00d267780' ||
                    '6a0c5fda3ade65b3fe84c9fa13e6988c07f04652f6723e3c9a4e7118f5f7' ||
                    '025b2c2af91ede15077bfa87fb5a685bc2c9e7abaa9de5c9ed28d0650d71' ||
                    'b20972f548c33e11e9e59695cf3f8b501692b044a6ae6f9c939df570cf68' ||
                    '41280bd3311ec6f2cdd0c4753bb0ed8b81b7d3e63d77781bdbbe78b8689f' ||
                    '0a691fa601f4aca95751bbe206099b80f49b7dc7059685903731f1f93f8f' ||
                    '55c2d96daf263eff67e908972c9f5cbfbe3a2b90ba65749ca1595db2463d' ||
                    'b4232f565b7436c6c3787e3bdc787be6637b8b1ef94b7dc9d2f79bf3725c' ||
                    '8535e81979e3239bf88950ae3c632ecc3dfcfa239fdfb37cbc3e9d1dd78f' ||
                    'a77bf1cd4d0f2df8283cebc9564aab6dcdad9c4d401456b79d2fce9c986c' ||
                    'd47defc55bfff5b57154332eff5c7d3edf8bebd6afbf003deb3f9ba27973' ||
                    '4ce9c833a523238aa1db8aa148d1dba6184391a6ad4b336a88482883605b' ||
                    'a1e1db133123ffbd6dd5bf9cb35a25c0ff038e25e3b4d6210ac200000000' ||
                    '49454e44ae426082', 'hex'
                    )
            );
    end if;

    create table message_response (
        "id" bigserial primary key,
        "created_at" timestamptz(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
        "updated_at" timestamptz(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
        "original_msg_id" bigserial NOT NULL,
        "responding_msg_id" bigserial NOT NULL,

        constraint fk_original_message foreign key(original_msg_id) references message(id),
        constraint fk_responding_message foreign key(responding_msg_id) references message(id)
    );

    select count(*) from message_response into row_count;
    if row_count = 0 then
        insert into message_response (original_msg_id, responding_msg_id) values (18, 5);
        insert into message_response (original_msg_id, responding_msg_id) values (18, 4);
        insert into message_response (original_msg_id, responding_msg_id) values (17, 3);
        insert into message_response (original_msg_id, responding_msg_id) values (17, 2);
        insert into message_response (original_msg_id, responding_msg_id) values (16, 1);
    end if;

    create table message_broadcast (
        "id" bigserial primary key,
        "created_at" timestamptz(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
        "updated_at" timestamptz(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
        "main_msg_id" bigserial NOT NULL,
        "broadcasting_msg_id" bigserial NOT NULL,

        constraint fk_original_message foreign key(main_msg_id) references message(id),
        constraint fk_broadcasting_message foreign key(broadcasting_msg_id) references message(id)
    );
end $$