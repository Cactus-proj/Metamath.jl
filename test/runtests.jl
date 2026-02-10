using Metamath
using Test

getenvsig(env) = map(f->length(getfield(env,f)),fieldnames(Metamath.Environment))
mmexample(fname) = joinpath(pkgdir(Metamath), "data", fname)
is_empty(env) = all(getenvsig(env) .== [0,0,0,0,0,0,0,1,0,0,1])

@testset "Metamath" begin
    @test is_empty(Metamath.globalenv)
    env = nothing

    @testset "demo.mm" begin
        @time env = Metamath.main(mmexample("demo.mm"))
        @test getenvsig(env) == (1,0,0,6,5,3,12,1,0,0,1)
        @test env == Metamath.globalenv

        empty!(env)
        @test is_empty(env)
    end

    @testset "miu.mm (5~KB)" begin
        @time mmverify!(env, mmexample("miu.mm"))
        @test getenvsig(env) == (1,0,0,5,6,2,11,1,0,0,1)
        empty!(env)
    end

    @testset "hol.mm (90~KB)" begin
        @time mmverify!(env, mmexample("hol.mm"))
        @test getenvsig(env) == (1,0,0,31,289,18,209,1,0,0,1)
        empty!(env)
    end

    @test is_empty(env)
end
